class_name FrameStats
extends RefCounted
## PLAN-099 (SPEC-172): estatística do tempo de quadro. Só mede; não usa RNG nem toca a simulação.
## Histograma de 1 ms por janela (reiniciável com lap) e no total. Intervalos acima de MAX_VALID não são quadros
## de jogo (janela minimizada, Alt-Tab, depurador) e ficam de fora, contados em `ignorados`.

const BUCKET_MS := 1.0
const BUCKETS := 200            # 0 a 199 ms; mais que isso cai no último
const MAX_VALID := 2.0          # segundos
const SLOW_33 := 1.0 / 30.0     # abaixo de 30 fps
const SLOW_50 := 1.0 / 20.0     # abaixo de 20 fps

class Acc:
	extends RefCounted
	var n := 0
	var sum := 0.0
	var worst := 0.0
	var slow33 := 0
	var slow50 := 0
	var hist := PackedInt32Array()

	func _init() -> void:
		hist.resize(FrameStats.BUCKETS)

	func add(dt: float) -> void:
		n += 1
		sum += dt
		worst = maxf(worst, dt)
		if dt > FrameStats.SLOW_33:
			slow33 += 1
		if dt > FrameStats.SLOW_50:
			slow50 += 1
		hist[mini(FrameStats.BUCKETS - 1, int(dt * 1000.0 / FrameStats.BUCKET_MS))] += 1

	## Limite superior (ms) do balde onde o percentil cai; nunca acima do pior quadro.
	func percentile_ms(p: float) -> float:
		if n == 0:
			return 0.0
		var target := int(ceil(p * float(n)))
		var seen := 0
		for i in hist.size():
			seen += hist[i]
			if seen >= target:
				return minf(float(i + 1) * FrameStats.BUCKET_MS, worst * 1000.0)
		return worst * 1000.0

	func summary() -> Dictionary:
		if n == 0:
			return {"quadros": 0, "fps": 0.0, "ms_medio": 0.0, "ms_p95": 0.0, "ms_p99": 0.0, "ms_max": 0.0, "lentos_33": 0, "lentos_50": 0}
		return {"quadros": n, "fps": snappedf(float(n) / sum, 0.1), "ms_medio": snappedf(sum / float(n) * 1000.0, 0.1),
			"ms_p95": snappedf(percentile_ms(0.95), 0.1), "ms_p99": snappedf(percentile_ms(0.99), 0.1),
			"ms_max": snappedf(worst * 1000.0, 0.1), "lentos_33": slow33, "lentos_50": slow50}

var _window := Acc.new()
var _total := Acc.new()
var ignorados := 0

## `dt` em segundos (o delta do _process).
func add(dt: float) -> void:
	if dt <= 0.0:
		return
	if dt > MAX_VALID:
		ignorados += 1
		return
	_window.add(dt)
	_total.add(dt)

func window() -> Dictionary:
	return _window.summary()

## Resumo da janela e recomeça a janela (o total segue acumulando).
func lap() -> Dictionary:
	var out := _window.summary()
	_window = Acc.new()
	return out

func total() -> Dictionary:
	var out := _total.summary()
	out["ignorados"] = ignorados
	return out

func reset() -> void:
	_window = Acc.new()
	_total = Acc.new()
	ignorados = 0

## Uma linha para notas e logs: "58 fps, p95 21 ms, max 64 ms, 3 abaixo de 30 fps".
func line() -> String:
	var s := _window.summary()
	if int(s.quadros) == 0:
		return "sem quadros medidos"
	return "%d fps, p95 %d ms, max %d ms, %d abaixo de 30 fps (em %d quadros)" % [int(round(float(s.fps))), int(round(float(s.ms_p95))),
		int(round(float(s.ms_max))), int(s.lentos_33), int(s.quadros)]

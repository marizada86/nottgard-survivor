extends Node
## Autoload "Sfx": sons sintetizados em código (sem arquivos) e um drone ambiente. Volume: bus master.

var _pool: Array = []
var _cache := {}
var _music: AudioStreamPlayer
var _last := {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in 10:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_pool.append(p)
	_music = AudioStreamPlayer.new()
	_music.volume_db = -22.0
	add_child(_music)

func play(name: String, vol_db: float = -8.0) -> void:
	var now := Time.get_ticks_msec()
	if now - int(_last.get(name, 0)) < 45:
		return
	_last[name] = now
	if not _cache.has(name):
		_cache[name] = _make(name)
	for p in _pool:
		if not p.playing:
			p.stream = _cache[name]
			p.volume_db = vol_db
			p.play()
			return

func start_music() -> void:
	if _music.playing:
		return
	_music.stream = _drone()
	_music.play()

func stop_music() -> void:
	_music.stop()

func _wav(samples: PackedFloat32Array, loop: bool = false) -> AudioStreamWAV:
	var s := AudioStreamWAV.new()
	s.format = AudioStreamWAV.FORMAT_16_BITS
	s.mix_rate = 22050
	s.stereo = false
	var bytes := PackedByteArray()
	bytes.resize(samples.size() * 2)
	for i in samples.size():
		bytes.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 32000.0))
	s.data = bytes
	if loop:
		s.loop_mode = AudioStreamWAV.LOOP_FORWARD
		s.loop_end = samples.size()
	return s

func _tone(freq: float, dur: float, decay: float, wave: String = "sine", slide: float = 0.0, noise: float = 0.0) -> PackedFloat32Array:
	var n := int(22050.0 * dur)
	var out := PackedFloat32Array()
	out.resize(n)
	var ph := 0.0
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in n:
		var t := float(i) / 22050.0
		var f := freq + slide * t
		ph += TAU * f / 22050.0
		var v := sin(ph)
		if wave == "saw":
			v = fposmod(ph / TAU, 1.0) * 2.0 - 1.0
		elif wave == "square":
			v = 1.0 if sin(ph) > 0.0 else -1.0
		v = v * (1.0 - noise) + rng.randf_range(-1.0, 1.0) * noise
		out[i] = v * exp(-t * decay) * minf(1.0, t * 400.0) * 0.5
	return out

func _cat(a: PackedFloat32Array, b: PackedFloat32Array) -> PackedFloat32Array:
	var o := a.duplicate()
	o.append_array(b)
	return o

func _make(name: String) -> AudioStreamWAV:
	match name:
		"hit": return _wav(_tone(220.0, 0.07, 40.0, "saw", -600.0, 0.35))
		"crit": return _wav(_cat(_tone(330.0, 0.05, 30.0, "square", 0.0, 0.2), _tone(660.0, 0.12, 22.0, "sine")))
		"swing": return _wav(_tone(400.0, 0.09, 30.0, "sine", -1800.0, 0.7))
		"cast": return _wav(_tone(520.0, 0.12, 20.0, "sine", 900.0, 0.1))
		"nova": return _wav(_tone(180.0, 0.35, 8.0, "sine", 260.0, 0.15))
		"hurt": return _wav(_tone(140.0, 0.16, 16.0, "saw", -300.0, 0.3))
		"pickup": return _wav(_tone(1100.0, 0.05, 45.0))
		"gold": return _wav(_cat(_tone(1400.0, 0.04, 50.0), _tone(1900.0, 0.06, 40.0)))
		"levelup": return _wav(_cat(_cat(_tone(523.0, 0.1, 10.0), _tone(659.0, 0.1, 10.0)), _cat(_tone(784.0, 0.1, 10.0), _tone(1047.0, 0.28, 6.0))))
		"item": return _wav(_cat(_tone(880.0, 0.08, 12.0), _tone(1320.0, 0.25, 7.0)))
		"boom": return _wav(_tone(70.0, 0.5, 6.0, "saw", -60.0, 0.5))
		"boss": return _wav(_tone(55.0, 0.9, 2.5, "saw", 20.0, 0.25))
		"click": return _wav(_tone(700.0, 0.03, 60.0, "square"))
		"win": return _wav(_cat(_cat(_tone(392.0, 0.14, 8.0), _tone(523.0, 0.14, 8.0)), _cat(_tone(659.0, 0.14, 8.0), _tone(784.0, 0.6, 4.0))))
		"dead": return _wav(_cat(_tone(196.0, 0.3, 5.0, "saw"), _tone(110.0, 0.7, 3.0, "saw", -20.0)))
	return _wav(_tone(440.0, 0.05, 40.0))

func _drone() -> AudioStreamWAV:
	var secs := 8.0
	var n := int(22050.0 * secs)
	var out := PackedFloat32Array()
	out.resize(n)
	for i in n:
		var t := float(i) / 22050.0
		var lfo := 0.6 + 0.4 * sin(TAU * t / secs)
		var v := sin(TAU * 55.0 * t) * 0.5 + sin(TAU * 82.5 * t) * 0.3 * lfo + sin(TAU * 110.5 * t) * 0.15 * (1.0 - lfo)
		out[i] = v * 0.4
	return _wav(out, true)

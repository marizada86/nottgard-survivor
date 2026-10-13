extends RefCounted
## PLAN-099 (SPEC-172): estatística de quadros, informações da máquina e a ligação no kit e no registro da run.

func _near(a: float, b: float, eps: float = 0.11) -> bool:
	return absf(a - b) <= eps

func run() -> Array:
	var out: Array = []

	# quadros estaveis a ~60 fps
	var fs := FrameStats.new()
	for i in 100:
		fs.add(1.0 / 60.0)
	var s := fs.window()
	if int(s.quadros) != 100 or not _near(float(s.fps), 60.0) or not _near(float(s.ms_medio), 16.7) or float(s.ms_max) > 16.8 or int(s.lentos_33) != 0:
		out.append("quadros estaveis: %s" % str(s))

	# percentis por balde: 95 quadros de 10 ms e 5 de 100 ms
	var pct := FrameStats.new()
	for i in 95:
		pct.add(0.010)
	for i in 5:
		pct.add(0.100)
	var p := pct.window()
	if not _near(float(p.ms_p95), 11.0) or not _near(float(p.ms_p99), 100.0) or not _near(float(p.ms_max), 100.0):
		out.append("percentis: p95 %s, p99 %s, max %s (esperado 11, 100, 100)" % [str(p.ms_p95), str(p.ms_p99), str(p.ms_max)])
	if int(p.lentos_33) != 5 or int(p.lentos_50) != 5:
		out.append("quadros lentos: %d abaixo de 30 fps, %d abaixo de 20 fps (esperado 5 e 5)" % [int(p.lentos_33), int(p.lentos_50)])

	# 40 ms esta abaixo de 30 fps mas nao de 20; 60 ms esta abaixo dos dois
	var slow := FrameStats.new()
	for i in 10:
		slow.add(0.040)
	for i in 2:
		slow.add(0.060)
	var sl := slow.window()
	if int(sl.lentos_33) != 12 or int(sl.lentos_50) != 2:
		out.append("limiares de lentidao: %s" % str(sl))

	# intervalos longos (janela minimizada) ficam de fora e sao contados
	var gap := FrameStats.new()
	gap.add(0.016)
	gap.add(3.5)
	gap.add(0.0)
	gap.add(-1.0)
	if int(gap.window().quadros) != 1 or gap.ignorados != 1:
		out.append("intervalos longos: %d quadros, %d ignorados (esperado 1 e 1)" % [int(gap.window().quadros), gap.ignorados])

	# lap zera a janela e o total segue
	var lap := FrameStats.new()
	for i in 30:
		lap.add(0.020)
	var first := lap.lap()
	for i in 10:
		lap.add(0.020)
	if int(first.quadros) != 30 or int(lap.window().quadros) != 10 or int(lap.total().quadros) != 40:
		out.append("lap: janela1 %d, janela2 %d, total %d (esperado 30, 10, 40)" % [int(first.quadros), int(lap.window().quadros), int(lap.total().quadros)])
	lap.reset()
	if int(lap.total().quadros) != 0 or int(lap.window().quadros) != 0:
		out.append("reset deveria zerar janela e total")

	# vazio e uma quadro enorme (cai no ultimo balde, max preservado)
	if FrameStats.new().line() != "sem quadros medidos":
		out.append("sem quadros deveria dizer 'sem quadros medidos'")
	var big := FrameStats.new()
	big.add(0.5)
	if not _near(float(big.window().ms_max), 500.0):
		out.append("quadro de 500 ms: max %s" % str(big.window().ms_max))

	# maquina: campos presentes e nada pessoal
	var m := MachineInfo.describe()
	for key in ["so", "cpu", "nucleos", "ram_mb", "gpu", "renderer", "driver", "janela", "tela", "hz", "modo", "godot", "web"]:
		if not m.has(key):
			out.append("MachineInfo sem o campo %s" % key)
	if int(m.get("nucleos", 0)) < 1:
		out.append("MachineInfo deveria contar ao menos 1 nucleo")
	var line := MachineInfo.short()
	var user := OS.get_environment("USERNAME")
	if user != "" and user.length() > 2 and line.to_lower().contains(user.to_lower()):
		out.append("a linha da maquina nao pode conter o nome de usuario")
	for forbidden in [OS.get_user_data_dir(), OS.get_executable_path().get_base_dir()]:
		if String(forbidden) != "" and line.contains(String(forbidden)):
			out.append("a linha da maquina nao pode conter caminhos")
	if line.strip_edges() == "":
		out.append("a linha da maquina nao pode ser vazia")

	# o contexto de cada nota leva a maquina e os quadros
	var ctx: Dictionary = Playtest.context()
	if not ctx.has("maquina") or not ctx.has("quadros"):
		out.append("o contexto da nota deveria ter maquina e quadros")

	# o registro da run aceita os campos novos em checkpoints, sem mexer no contrato
	var b := Battle.new(5, "durvall", "dagruve")
	b.run_record.begin(b, {})
	var fs2 := FrameStats.new()
	for i in 20:
		fs2.add(0.017)
	b.run_record.checkpoint(b, "minute", {"quadros": fs2.lap()})
	b.run_record.checkpoint(b, "finish", {"quadros_total": fs2.total(), "maquina": MachineInfo.describe()})
	var snap: Dictionary = b.run_record.snapshot(b, "dead")
	var hist: Array = snap.history
	var minute: Dictionary = hist[hist.size() - 2]
	var finish: Dictionary = hist[hist.size() - 1]
	if String(minute.kind) != "minute" or not Dictionary(minute.details).has("quadros") or int(Dictionary(minute.details).quadros.quadros) != 20:
		out.append("checkpoint minute deveria carregar os quadros: %s" % str(minute))
	if String(finish.kind) != "finish" or not Dictionary(finish.details).has("maquina") or not Dictionary(finish.details).has("quadros_total"):
		out.append("checkpoint finish deveria carregar maquina e quadros_total")
	for key in ["schema_version", "game_id", "run_id", "outcome", "history", "build", "score", "counters"]:
		if not snap.has(key):
			out.append("o contrato v1 perdeu a chave %s" % key)
	if int(snap.schema_version) != RunRecord.SCHEMA_VERSION:
		out.append("schema_version mudou")
	return out

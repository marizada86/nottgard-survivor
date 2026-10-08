class_name WalkTrace
extends RefCounted
## Diagnóstico do patinar ao andar (BUG-028, SPEC-144). Tudo opt-in: sem a flag, nada é criado nem gravado.
##
## Liga com `--walk-debug` (argumento de usuário: `godot ... -- --walk-debug`) ou NOTT_WALK_DEBUG=1.
## Opções (mesmo nome em argumento `--x=valor` ou variável NOTT_X em maiúsculas, `-` vira `_`):
##   walk-break=switch,idle,reset  liga os breakpoints condicionais do HeroView (precisa do depurador do Godot)
##   walk-break-n=3                trocas de tira dentro de walk-break-window para disparar "switch"
##   walk-break-window=0.5         janela em segundos
##   walk-force=e|se|s|sw|w|nw|n|ne  força a direção da tira, ignorando o deslocamento (isola arte de código)
##   walk-smooth                   liga a histerese de setor (_stable_direction), experimento da hipótese H1
##   walk-fps=15                   troca o fps das tiras de andar, experimento da hipótese H3
##   walk-controls                 F9 congela/descongela a run, F10 avança um tick (usa get_tree().paused)
## O CSV vai para user://walk_trace/ (no Windows: %APPDATA%\Godot\app_userdata\<projeto>\walk_trace\).

const DIR := "user://walk_trace"
const HEADER := "tick,t_ms,render_frames,physics_frame,fps,hero,anim,frame,flip_h,sx,sy,dx,dy,moving,still_ticks,sector,input,speed_scale,event,detail"
const KEYS := [KEY_A, KEY_D, KEY_W, KEY_S, KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN]
const SECTORS := [&"e", &"se", &"s", &"sw", &"w", &"nw", &"n", &"ne"]

## Para testes: liga o diagnóstico sem argumentos.
static var forced_enabled := false
## Para testes: não grava CSV; e força "tecla de movimento pressionada" (-1 = ler o Input de verdade).
static var disk_enabled := true
static var forced_pressed := -1
static var _owner_id := 0
static var _cached_enabled := -1

var owner_id := 0
var hero := ""
var path := ""
var tick := 0
var events_total: Dictionary = {}
var _file: FileAccess
var _last_render_frames := 0
var _switch_times: Array[int] = []
var _last_row := {}
var break_hits := 0

static func enabled() -> bool:
	if forced_enabled:
		return true
	if _cached_enabled < 0:
		_cached_enabled = 1 if (option("walk-debug") != "" and option("walk-debug") != "0") else 0
	return _cached_enabled == 1

## Valor de `--nome=valor` (ou `--nome` = "1") nos argumentos de usuário, senão NOTT_NOME; "" se ausente.
static func option(key: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg == "--" + key:
			return "1"
		if arg.begins_with("--" + key + "="):
			return arg.substr(key.length() + 3)
	return OS.get_environment("NOTT_" + key.to_upper().replace("-", "_"))

static func forced_direction() -> Vector2:
	var key := option("walk-force")
	var index := SECTORS.find(StringName(key))
	if index < 0:
		return Vector2.ZERO
	return Vector2.RIGHT.rotated(index * TAU / 8.0)

## Só um HeroView por vez é dono do log (o herói da run); cópias (iscas) e visuais de menu ficam de fora.
static func open(hero_id: String, node_id: int) -> WalkTrace:
	if not enabled() or _owner_id != 0:
		return null
	var trace := WalkTrace.new()
	trace.owner_id = node_id
	trace.hero = hero_id
	_owner_id = node_id
	if disk_enabled:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DIR))
		trace.path = "%s/trace_%s_%s.csv" % [DIR, hero_id, Time.get_datetime_string_from_system().replace(":", "-")]
		trace._file = FileAccess.open(trace.path, FileAccess.WRITE)
		if trace._file != null:
			trace._file.store_line(HEADER)
			print("WalkTrace: gravando em ", ProjectSettings.globalize_path(trace.path))
	return trace

func close() -> void:
	if _file != null:
		_file.flush()
		_file.close()
		_file = null
	if _owner_id == owner_id:
		_owner_id = 0

static func reset_owner() -> void:
	_owner_id = 0

static func input_pressed() -> bool:
	if forced_pressed >= 0:
		return forced_pressed == 1
	for key in KEYS:
		if Input.is_physical_key_pressed(key):
			return true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return true
	var tree := Engine.get_main_loop() as SceneTree
	var game: Node = tree.root.get_node_or_null("Game") if tree != null else null
	return game != null and game.movement_joystick() != Vector2.ZERO

## Registra um tick de sync_visual. Devolve a lista de eventos do tick (para o gancho de breakpoint).
## `before` = {anim, frame} antes de decidir a tira; `after` = estado depois.
func record_tick(screen: Vector2, delta: Vector2, moving: bool, still_ticks: int, sector: int, before: Dictionary, anim: StringName, frame: int, flip_h: bool, speed_scale: float, pressed: bool, frame_count: int) -> Array[String]:
	tick += 1
	var now := Time.get_ticks_msec()
	var render_frames := Engine.get_process_frames()
	var events: Array[String] = []
	var detail := ""
	var prev_anim: StringName = before.anim
	if prev_anim != anim:
		var prev_walk := String(prev_anim).begins_with("move")
		var is_walk := String(anim).begins_with("move")
		if prev_walk and is_walk:
			events.append("switch")
			detail = "%s(f%d)->%s" % [prev_anim, int(before.frame), anim]
			_switch_times.append(now)
		elif prev_walk and anim == &"idle":
			events.append("idle_drop" if pressed else "stop")
			detail = "%s(f%d)->idle input=%s" % [prev_anim, int(before.frame), str(pressed)]
		elif prev_anim == &"idle" and is_walk:
			events.append("start")
			detail = "idle->%s" % anim
	elif String(anim).begins_with("move") and frame < int(before.frame) and int(before.frame) != frame_count - 1:
		events.append("reset")
		detail = "%s f%d->f%d" % [anim, int(before.frame), frame]
	for event in events:
		events_total[event] = int(events_total.get(event, 0)) + 1
	_last_row = {"anim": anim, "frame": frame, "flip": flip_h, "sx": screen.x, "sy": screen.y, "dx": delta.x, "dy": delta.y, "moving": moving, "still": still_ticks, "sector": sector, "input": pressed, "scale": speed_scale}
	_write(now, render_frames - _last_render_frames, ",".join(PackedStringArray(events)), detail)
	_last_render_frames = render_frames
	return events

## Mudança de quadro (sinal frame_changed do sprite): mostra o ritmo real da animação contra os ticks.
func record_frame(anim: StringName, frame: int) -> void:
	if _last_row.is_empty():
		return
	_last_row.anim = anim
	_last_row.frame = frame
	_write(Time.get_ticks_msec(), Engine.get_process_frames() - _last_render_frames, "frame", "")

func _write(now: int, render_frames: int, event: String, detail: String) -> void:
	if _file == null:
		return
	var r: Dictionary = _last_row
	_file.store_line("%d,%d,%d,%d,%d,%s,%s,%d,%d,%.2f,%.2f,%.3f,%.3f,%d,%d,%d,%d,%.2f,%s,%s" % [
		tick, now, render_frames, Engine.get_physics_frames(), int(Engine.get_frames_per_second()), hero, r.anim, r.frame, int(r.flip),
		r.sx, r.sy, r.dx, r.dy, int(r.moving), r.still, r.sector, int(r.input), r.scale, event, detail])
	if tick % 30 == 0:
		_file.flush()

## Decide se o gancho de breakpoint deve parar o depurador neste tick.
func should_break(events: Array[String]) -> bool:
	var wanted := option("walk-break").split(",", false)
	if wanted.is_empty():
		return false
	var hit := false
	if events.has("switch") and wanted.has("switch"):
		var window_ms := int(float(option("walk-break-window") if option("walk-break-window") != "" else "0.5") * 1000.0)
		var needed := int(option("walk-break-n") if option("walk-break-n") != "" else "3")
		var now := Time.get_ticks_msec()
		while not _switch_times.is_empty() and now - _switch_times[0] > window_ms:
			_switch_times.pop_front()
		hit = _switch_times.size() >= needed
	if events.has("idle_drop") and wanted.has("idle"):
		hit = true
	if events.has("reset") and wanted.has("reset"):
		hit = true
	if hit:
		break_hits += 1
	return hit

func summary() -> String:
	return "ticks=%d eventos=%s breakpoints=%d" % [tick, str(events_total), break_hits]

extends Node
## Autoload "Game": perfil, save/load, parâmetros da run e log para o kit de playtest.

const SAVE_PATH := "user://profile.json"

var profile: Profile
var persisted := false
var _save_path := SAVE_PATH
var qa_sandbox := false
var qa_session_id := ""
var qa_launch: Dictionary = {}
var qa_menu_tab := 0
var qa_error := ""
var _real_save_signature: Dictionary = {}
var run_hero := "durvall"
var run_stage := "dagruve"
var last_result: Dictionary = {}
var last_summary: Dictionary = {}
var log_lines: Array = []
var screen_name := "menu"

func _ready() -> void:
	ensure_input_actions()
	load_profile()
	apply_settings()
	logline("Jogo iniciado v%s" % Version.VERSION)

func ensure_input_actions() -> void:
	if InputMap.has_action("hero_active"):
		return
	InputMap.add_action("hero_active")
	var key := InputEventKey.new()
	key.physical_keycode = KEY_Q
	InputMap.action_add_event("hero_active", key)
	var mouse := InputEventMouseButton.new()
	mouse.button_index = MOUSE_BUTTON_RIGHT
	InputMap.action_add_event("hero_active", mouse)
	var joy := InputEventJoypadButton.new()
	joy.button_index = JOY_BUTTON_RIGHT_SHOULDER
	InputMap.action_add_event("hero_active", joy)

func load_profile() -> void:
	var d := {}
	if FileAccess.file_exists(_save_path):
		var f := FileAccess.open(_save_path, FileAccess.READ)
		if f != null:
			var parsed: Variant = JSON.parse_string(f.get_as_text())
			if parsed is Dictionary:
				d = parsed
	profile = Profile.new(d)
	persisted = FileAccess.file_exists(_save_path)

func save() -> void:
	var f := FileAccess.open(_save_path, FileAccess.WRITE)
	if f == null:
		persisted = false
		return
	f.store_string(JSON.stringify(profile.data, "\t"))
	persisted = true

func real_save_signature() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {"exists": false, "hash": ""}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {"exists": false, "hash": ""}
	return {"exists": true, "hash": file.get_as_text().sha256_text()}

static func qa_sandbox_directory(session_id: String) -> String:
	return "user://qa-sandbox/%s" % session_id

static func qa_sandbox_global_directory(session_id: String) -> String:
	return ProjectSettings.globalize_path(qa_sandbox_directory(session_id))

func begin_qa_sandbox(session_id: String) -> bool:
	qa_error = ""
	if not Version.qa_enabled():
		qa_error = "O Navegador QA so esta disponivel no perfil QA Interno."
		return false
	if qa_sandbox:
		return true
	_real_save_signature = real_save_signature()
	qa_sandbox = true
	qa_session_id = session_id
	var sandbox_dir := qa_sandbox_directory(session_id)
	_save_path = "%s/profile.json" % sandbox_dir
	if DirAccess.make_dir_recursive_absolute(qa_sandbox_global_directory(session_id)) != OK:
		qa_sandbox = false
		qa_session_id = ""
		_save_path = SAVE_PATH
		qa_error = "Nao foi possivel preparar o sandbox QA. Verifique o acesso a pasta de dados do jogo."
		return false
	var copied: Variant = JSON.parse_string(JSON.stringify(profile.data))
	profile = Profile.new(copied if copied is Dictionary else {})
	persisted = false
	return true

func end_qa_sandbox() -> bool:
	if not qa_sandbox:
		return true
	var unchanged := real_save_signature() == _real_save_signature
	qa_sandbox = false
	qa_session_id = ""
	qa_launch.clear()
	_save_path = SAVE_PATH
	load_profile()
	return unchanged

func start_qa_run(request: Dictionary) -> bool:
	if not Version.qa_enabled():
		qa_error = "O Navegador QA so esta disponivel no perfil QA Interno."
		return false
	var session := "qa-%s" % Time.get_datetime_string_from_system().replace(":", "").replace("-", "").replace(" ", "-")
	if not begin_qa_sandbox(session):
		return false
	qa_launch = request.duplicate(true)
	run_hero = String(request.get("hero_id", "durvall"))
	run_stage = String(request.get("stage_id", "dagruve"))
	logline("QA: %s em %s" % [String(request.get("target_state", "running")), run_stage])
	if get_tree().change_scene_to_file("res://ui/run.tscn") != OK:
		qa_error = "Nao foi possivel abrir a run QA."
		end_qa_sandbox()
		return false
	return true

func apply_settings() -> void:
	var s: Dictionary = profile.data.settings
	AudioServer.set_bus_volume_db(0, linear_to_db(clampf(float(s.volume), 0.0, 1.0)))
	if has_node("/root/Sfx"):
		Sfx.apply_mix(s)
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if bool(s.fullscreen) else DisplayServer.WINDOW_MODE_WINDOWED
	if DisplayServer.window_get_mode() != mode:
		DisplayServer.window_set_mode(mode)

func toggle_fullscreen() -> void:
	profile.data.settings.fullscreen = not bool(profile.data.settings.fullscreen)
	apply_settings()
	save()

func aim_mode() -> int:
	return Battle.Aim.MOUSE if String(profile.data.settings.aim) == "mouse" else Battle.Aim.AUTO

func set_aim(mode: int) -> void:
	profile.data.settings.aim = "mouse" if mode == Battle.Aim.MOUSE else "auto"
	save()

func difficulty() -> float:
	return 1.0 + 0.25 * int(profile.data.settings.difficulty)

func battle_ctx() -> Dictionary:
	var meta := profile.meta_mods()
	Hero.add_mods(meta, profile.bonus_mods())
	Hero.add_mods(meta, {"gold_pct": 0.25 * int(profile.data.settings.difficulty)})
	return {"meta_mods": meta, "bonus_mods": {}, "difficulty": difficulty()}

func start_run(hero_id: String, stage_id: String) -> void:
	run_hero = hero_id
	run_stage = stage_id
	logline("Run: %s em %s" % [hero_id, stage_id])
	get_tree().change_scene_to_file("res://ui/run.tscn")

func finish_run(result: Dictionary) -> void:
	last_result = result
	last_summary = profile.apply_run(result)
	save()
	logline("Fim da run: %s | %d abates | +%d moedas" % ["vitória" if result.won else "derrota", result.kills, last_summary.earned])

func goto_menu() -> void:
	get_tree().paused = false
	screen_name = "menu"
	get_tree().change_scene_to_file("res://ui/menu.tscn")

func logline(msg: String) -> void:
	var t := Time.get_time_string_from_system()
	log_lines.append("[%s] %s" % [t, msg])
	if log_lines.size() > 400:
		log_lines = log_lines.slice(log_lines.size() - 400)

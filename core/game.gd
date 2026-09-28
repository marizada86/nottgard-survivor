extends Node
## Autoload "Game": perfil, save/load, parâmetros da run e log para o kit de playtest.

const SAVE_PATH := "user://profile.json"
const SAVE_BACKUP_SUFFIX := ".bak"
const SAVE_TEMP_SUFFIX := ".tmp"
const SAVE_CORRUPT_SUFFIX := ".corrupt"

var profile: Profile
var persisted := false
var save_notice := ""
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
	if save_notice != "":
		logline(save_notice)
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

static func profile_backup_path(path: String) -> String:
	return path + SAVE_BACKUP_SUFFIX

static func profile_temp_path(path: String) -> String:
	return path + SAVE_TEMP_SUFFIX

## Resultado: {valid, exists, data, text}. Um perfil só é válido se for objeto JSON.
static func read_profile_file(path: String) -> Dictionary:
	var result := {"valid": false, "exists": FileAccess.file_exists(path), "data": {}, "text": ""}
	if not bool(result.exists):
		return result
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return result
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK:
		return result
	var parsed: Variant = json.data
	if parsed is Dictionary:
		result.valid = true
		result.data = parsed
		result.text = text
	return result

static func _write_text(path: String, text: String) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(text)
	file.flush()
	var ok := file.get_error() == OK
	file.close()
	return ok

static func _replace_with_temp(temp_path: String, target_path: String) -> bool:
	return DirAccess.rename_absolute(ProjectSettings.globalize_path(temp_path), ProjectSettings.globalize_path(target_path)) == OK

static func _write_valid_file_atomically(path: String, text: String) -> bool:
	var temp_path := profile_temp_path(path)
	if not _write_text(temp_path, text):
		return false
	if not bool(read_profile_file(temp_path).valid):
		return false
	return _replace_with_temp(temp_path, path)

static func _corrupt_archive_path(path: String) -> String:
	var candidate := path + SAVE_CORRUPT_SUFFIX
	var suffix := 1
	while FileAccess.file_exists(candidate):
		candidate = "%s%s-%d" % [path, SAVE_CORRUPT_SUFFIX, suffix]
		suffix += 1
	return candidate

static func _preserve_corrupt_profile(path: String) -> bool:
	if not FileAccess.file_exists(path):
		return true
	return DirAccess.rename_absolute(ProjectSettings.globalize_path(path), ProjectSettings.globalize_path(_corrupt_archive_path(path))) == OK

func load_profile() -> void:
	save_notice = ""
	var primary := read_profile_file(_save_path)
	var backup := read_profile_file(profile_backup_path(_save_path))
	var d := {}
	if bool(primary.valid):
		d = primary.data
	elif bool(backup.valid):
		d = backup.data
		save_notice = "O save principal apresentou problema; o progresso foi recuperado do backup local."
	elif bool(primary.exists) or bool(backup.exists):
		save_notice = "Não foi possível ler o save local. Os arquivos foram preservados para diagnóstico."
	profile = Profile.new(d)
	persisted = bool(primary.valid) or bool(backup.valid)

func save() -> void:
	if profile == null:
		persisted = false
		save_notice = "Não foi possível salvar: perfil indisponível."
		return
	var text := JSON.stringify(profile.data, "\t")
	var temp_path := profile_temp_path(_save_path)
	if not _write_text(temp_path, text) or not bool(read_profile_file(temp_path).valid):
		persisted = false
		save_notice = "Não foi possível gravar o save. O progresso anterior foi preservado."
		return
	var primary := read_profile_file(_save_path)
	if bool(primary.valid):
		if not _write_valid_file_atomically(profile_backup_path(_save_path), String(primary.text)):
			persisted = false
			save_notice = "Não foi possível preparar o backup do save; o progresso anterior foi preservado."
			return
	elif bool(primary.exists) and not _preserve_corrupt_profile(_save_path):
		persisted = false
		save_notice = "O save com problema não pôde ser preservado; nenhuma alteração foi gravada."
		return
	if not _replace_with_temp(temp_path, _save_path) or not bool(read_profile_file(_save_path).valid):
		persisted = false
		save_notice = "Não foi possível finalizar o save. O backup local foi preservado."
		return
	persisted = true

func consume_save_notice() -> String:
	var notice := save_notice
	save_notice = ""
	return notice

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

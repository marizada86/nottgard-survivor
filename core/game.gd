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
var touch_preview := false
var controls = preload("res://core/controller_input.gd").new()

func touch_controls_enabled() -> bool:
	return touch_preview or OS.has_feature("android") or OS.has_feature("ios") or "--mobile-controls" in OS.get_cmdline_user_args()

func touch_safe_rect() -> Rect2:
	var rect := get_viewport().get_visible_rect()
	if OS.has_feature("android") or OS.has_feature("ios"):
		var safe := DisplayServer.get_display_safe_area()
		if safe.size.x > 0 and safe.size.y > 0:
			var transform := get_viewport().get_screen_transform().affine_inverse()
			rect = rect.intersection(transform * Rect2(safe))
	return rect.grow(-16.0)

func touch_target_size() -> float:
	if OS.has_feature("android") or OS.has_feature("ios"):
		var scale := get_viewport().get_screen_transform().get_scale().y
		return maxf(56.0, 48.0 * maxf(1.0, DisplayServer.screen_get_dpi() / 160.0) / maxf(0.1, scale))
	return 56.0

const JOYSTICK_DEADZONE := 0.24
const ACTION_MOVE_LEFT: StringName = &"joy_move_left"
const ACTION_MOVE_RIGHT: StringName = &"joy_move_right"
const ACTION_MOVE_UP: StringName = &"joy_move_up"
const ACTION_MOVE_DOWN: StringName = &"joy_move_down"
const ACTION_AIM_LEFT: StringName = &"joy_aim_left"
const ACTION_AIM_RIGHT: StringName = &"joy_aim_right"
const ACTION_AIM_UP: StringName = &"joy_aim_up"
const ACTION_AIM_DOWN: StringName = &"joy_aim_down"
const ACTION_RUN_PAUSE: StringName = &"run_pause"
const ACTION_RUN_AIM: StringName = &"run_toggle_aim"
const ACTION_RUN_INTERACT: StringName = &"run_interact"
const ACTION_RUN_EXTRACT: StringName = &"run_extract"
const ACTION_RUN_ITEMS: StringName = &"run_items"
const ACTION_RUN_SPEED: StringName = &"run_speed"
const ACTION_RUN_REROLL: StringName = &"run_reroll"
const ACTION_OFFER_DETAILS: StringName = &"offer_details"

func _ready() -> void:
	var user_args := OS.get_cmdline_user_args()
	var profile_arg := user_args.find("--controller-profile")
	if profile_arg >= 0 and profile_arg + 1 < user_args.size():
		_save_path = user_args[profile_arg + 1]
	controls.name = "ControllerInput"
	add_child(controls)
	ensure_input_actions()
	load_profile()
	ensure_input_actions()
	apply_settings()
	CursorSkin.install(get_tree())  # SPEC-132: cursor temático (sem arte, fica o do sistema)
	if save_notice != "":
		logline(save_notice)
	logline("Jogo iniciado v%s (%s)" % [Version.VERSION, Version.build_id()])

func ensure_input_actions() -> void:
	# Substituir apenas bindings de controle; preservar teclado e mouse.
	for action in InputMap.get_actions():
		if String(action).begins_with("joy_") or String(action).begins_with("run_") or action in [&"hero_active", &"offer_details", &"ui_accept", &"ui_cancel", &"ui_left", &"ui_right", &"ui_up", &"ui_down"]:
			for event in InputMap.action_get_events(action):
				if event is InputEventJoypadButton or event is InputEventJoypadMotion:
					InputMap.action_erase_event(action, event)
	_add_input_event(&"hero_active", _key_event(KEY_Q))
	_add_input_event(&"hero_active", _mouse_event(MOUSE_BUTTON_RIGHT))
	_add_input_event(&"hero_active", _joy_button_event(controls.button("hero_active")))
	_add_input_event(ACTION_MOVE_LEFT, _joy_axis_event(JOY_AXIS_LEFT_X, -1.0))
	_add_input_event(ACTION_MOVE_RIGHT, _joy_axis_event(JOY_AXIS_LEFT_X, 1.0))
	_add_input_event(ACTION_MOVE_UP, _joy_axis_event(JOY_AXIS_LEFT_Y, -1.0))
	_add_input_event(ACTION_MOVE_DOWN, _joy_axis_event(JOY_AXIS_LEFT_Y, 1.0))
	_add_input_event(ACTION_MOVE_LEFT, _joy_button_event(JOY_BUTTON_DPAD_LEFT))
	_add_input_event(ACTION_MOVE_RIGHT, _joy_button_event(JOY_BUTTON_DPAD_RIGHT))
	_add_input_event(ACTION_MOVE_UP, _joy_button_event(JOY_BUTTON_DPAD_UP))
	_add_input_event(ACTION_MOVE_DOWN, _joy_button_event(JOY_BUTTON_DPAD_DOWN))
	_add_input_event(ACTION_AIM_LEFT, _joy_axis_event(JOY_AXIS_RIGHT_X, -1.0))
	_add_input_event(ACTION_AIM_RIGHT, _joy_axis_event(JOY_AXIS_RIGHT_X, 1.0))
	_add_input_event(ACTION_AIM_UP, _joy_axis_event(JOY_AXIS_RIGHT_Y, -1.0))
	_add_input_event(ACTION_AIM_DOWN, _joy_axis_event(JOY_AXIS_RIGHT_Y, 1.0))
	_add_input_event(ACTION_RUN_PAUSE, _key_event(KEY_ESCAPE))
	_add_input_event(ACTION_RUN_PAUSE, _joy_button_event(JOY_BUTTON_START))
	_add_input_event(ACTION_RUN_AIM, _key_event(KEY_TAB))
	_add_input_event(ACTION_RUN_AIM, _joy_button_event(controls.button("run_toggle_aim")))
	_add_input_event(ACTION_RUN_INTERACT, _key_event(KEY_E))
	_add_input_event(ACTION_RUN_INTERACT, _joy_button_event(controls.button("run_interact")))
	_add_input_event(ACTION_RUN_EXTRACT, _key_event(KEY_X))
	_add_input_event(ACTION_RUN_ITEMS, _key_event(KEY_C))
	_add_input_event(ACTION_RUN_ITEMS, _joy_button_event(controls.button("run_items")))
	_add_input_event(ACTION_RUN_SPEED, _key_event(KEY_F))
	_add_input_event(ACTION_RUN_SPEED, _key_event(KEY_T))
	_add_input_event(ACTION_RUN_REROLL, _key_event(KEY_R))
	_add_input_event(ACTION_RUN_REROLL, _joy_button_event(controls.button("run_reroll")))
	_add_input_event(ACTION_OFFER_DETAILS, _key_event(KEY_SHIFT))
	_add_input_event(ACTION_OFFER_DETAILS, _joy_button_event(controls.button("offer_details")))
	_add_input_event(&"ui_accept", _joy_button_event(controls.action_button("ui_accept")))
	_add_input_event(&"ui_cancel", _joy_button_event(controls.action_button("ui_cancel")))
	_add_input_event(&"ui_left", _joy_button_event(JOY_BUTTON_DPAD_LEFT))
	_add_input_event(&"ui_right", _joy_button_event(JOY_BUTTON_DPAD_RIGHT))
	_add_input_event(&"ui_up", _joy_button_event(JOY_BUTTON_DPAD_UP))
	_add_input_event(&"ui_down", _joy_button_event(JOY_BUTTON_DPAD_DOWN))
	_add_input_event(&"ui_left", _joy_axis_event(JOY_AXIS_LEFT_X, -1.0))
	_add_input_event(&"ui_right", _joy_axis_event(JOY_AXIS_LEFT_X, 1.0))
	_add_input_event(&"ui_up", _joy_axis_event(JOY_AXIS_LEFT_Y, -1.0))
	_add_input_event(&"ui_down", _joy_axis_event(JOY_AXIS_LEFT_Y, 1.0))
	for action in [ACTION_MOVE_LEFT, ACTION_MOVE_RIGHT, ACTION_MOVE_UP, ACTION_MOVE_DOWN,
		ACTION_AIM_LEFT, ACTION_AIM_RIGHT, ACTION_AIM_UP, ACTION_AIM_DOWN]:
		InputMap.action_set_deadzone(action, controls.deadzone(action in [ACTION_AIM_LEFT, ACTION_AIM_RIGHT, ACTION_AIM_UP, ACTION_AIM_DOWN]))
	for action in [&"ui_left", &"ui_right", &"ui_up", &"ui_down"]:
		InputMap.action_set_deadzone(action, controls.deadzone())


func _add_input_event(action: StringName, event: InputEvent) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for current in InputMap.action_get_events(action):
		if current.is_match(event):
			return
	InputMap.action_add_event(action, event)


func _key_event(keycode: Key) -> InputEventKey:
	var key := InputEventKey.new()
	key.physical_keycode = keycode
	return key


func _mouse_event(button: MouseButton) -> InputEventMouseButton:
	var mouse := InputEventMouseButton.new()
	mouse.button_index = button
	return mouse


func _joy_button_event(button: int) -> InputEventJoypadButton:
	var joy := InputEventJoypadButton.new()
	joy.button_index = button
	joy.device = controls.active_device if not controls.disconnected else 99
	return joy


func _joy_axis_event(axis: JoyAxis, value: float) -> InputEventJoypadMotion:
	var joy := InputEventJoypadMotion.new()
	joy.axis = axis
	joy.axis_value = value
	joy.device = controls.active_device if not controls.disconnected else 99
	return joy


static func stick_vector(raw: Vector2, deadzone: float = JOYSTICK_DEADZONE) -> Vector2:
	var length := minf(raw.length(), 1.0)
	if length <= deadzone:
		return Vector2.ZERO
	return raw.normalized() * inverse_lerp(deadzone, 1.0, length)


func movement_joystick() -> Vector2:
	return controls.stick()


func manual_aim_joystick() -> Vector2:
	return controls.stick(true)

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
	if not Version.evidence_enabled():
		qa_error = "O Navegador QA so esta disponivel na build de playtest."
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
	if not Version.evidence_enabled():
		qa_error = "O Navegador QA so esta disponivel na build de playtest."
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

const SUPPORTED_RESOLUTIONS = ["1280x720", "1600x900", "1920x1080"]
const WINDOW_MODES = ["windowed", "borderless", "fullscreen"]

## SPEC-116: opção de acessibilidade; desliga a pausa de acerto e reduz as partículas novas de impacto.
func reduced_impact() -> bool:
	return bool(profile.data.settings.get("reduced_impact", false))

func apply_settings() -> void:
	var s: Dictionary = profile.data.settings
	AudioServer.set_bus_volume_db(0, linear_to_db(clampf(float(s.volume), 0.0, 1.0)))
	if has_node("/root/Sfx"):
		Sfx.apply_mix(s)
	if OS.has_feature("android") or OS.has_feature("ios"):
		return
	var style := String(s.get("window_mode", "windowed"))
	if not (style in WINDOW_MODES):
		style = "windowed"
		s.window_mode = style
	s.fullscreen = style == "fullscreen" # Compatibilidade com perfis e integrações legadas.
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, style == "borderless")
	DisplayServer.window_set_size(resolution_to_size(String(s.get("resolution", "1280x720"))))
	if style == "fullscreen":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func resolution_to_size(resolution: String) -> Vector2i:
	if not (resolution in SUPPORTED_RESOLUTIONS):
		return Vector2i(1280, 720)
	var parts := resolution.split("x", false)
	return Vector2i(int(parts[0]), int(parts[1]))


func set_window_mode(style: String) -> void:
	if not (style in WINDOW_MODES):
		return
	profile.data.settings.window_mode = style
	profile.data.settings.fullscreen = style == "fullscreen"
	apply_settings()
	save()


func set_resolution(resolution: String) -> void:
	if not (resolution in SUPPORTED_RESOLUTIONS):
		return
	profile.data.settings.resolution = resolution
	apply_settings()
	save()


func toggle_fullscreen() -> void:
	set_window_mode("windowed" if String(profile.data.settings.get("window_mode", "windowed")) == "fullscreen" else "fullscreen")

func aim_mode() -> int:
	if touch_controls_enabled():
		return Battle.Aim.AUTO
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
	return {"meta_mods": meta, "bonus_mods": {}, "difficulty": difficulty(), "abyss_marks": run_abyss_marks()}

## Marcas escolhidas no Quartel (SPEC-141); a escolha fica no perfil e cada marca só vale se a conquista dela foi ganha (SPEC-143).
func abyss_marks() -> Dictionary:
	return AbyssMarks.normalize(profile.data.settings.get("abyss_marks", {}))

func run_abyss_marks() -> Dictionary:
	return AbyssMarks.keep_unlocked(abyss_marks(), profile.abyss_mark_unlocked)

func set_abyss_marks(marks: Dictionary) -> void:
	profile.data.settings["abyss_marks"] = AbyssMarks.normalize(marks)
	save()

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
	var line := "[%s] %s" % [t, msg]
	log_lines.append(line)
	if log_lines.size() > 400:
		log_lines = log_lines.slice(log_lines.size() - 400)
	if is_inside_tree() and Version.evidence_enabled():
		var kit := get_node_or_null("/root/Playtest")
		if kit != null:
			kit.append_game_log(line)

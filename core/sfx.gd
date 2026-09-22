extends Node
## Orquestrador de áudio orientado por manifesto: variantes, prioridade, buses,
## música/ambiência por fase e compatibilidade com as chamadas legadas.

const MANIFEST_PATH := "res://data/audio_manifest.json"
const VOICE_COUNT := 24
const DEFAULT_OVERRIDE := 100.0

var _events: Dictionary = {}
var _aliases: Dictionary = {}
var _music_defs: Dictionary = {}
var _ambience_defs: Dictionary = {}
var _voices: Array[AudioStreamPlayer] = []
var _voice_priority: Array[int] = []
var _voice_started: Array[int] = []
var _last_played: Dictionary = {}
var _variant_cursor: Dictionary = {}
var _context_hero := "durvall"
var _context_stage := "dagruve"

var _music_a: AudioStreamPlayer
var _music_b: AudioStreamPlayer
var _music_front_a := true
var _music_key := ""
var _ambience: AudioStreamPlayer
var _ambience_key := ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_ensure_buses()
	_load_manifest()
	for i in VOICE_COUNT:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_voices.append(player)
		_voice_priority.append(0)
		_voice_started.append(0)
	_music_a = _new_loop_player("Music")
	_music_b = _new_loop_player("Music")
	_ambience = _new_loop_player("Ambience")
	get_tree().node_added.connect(_on_node_added)
	call_deferred("_wire_existing_controls")
	call_deferred("_apply_profile_mix")


func _new_loop_player(bus_name: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.bus = bus_name
	add_child(player)
	return player


func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		_wire_button(node)


func _wire_existing_controls() -> void:
	for node in get_tree().get_nodes_in_group("__audio_ui_wired"):
		_wire_button(node)
	_wire_controls_recursive(get_tree().root)


func _wire_controls_recursive(node: Node) -> void:
	if node is BaseButton:
		_wire_button(node)
	for child in node.get_children():
		_wire_controls_recursive(child)


func _wire_button(button: BaseButton) -> void:
	if button.has_meta("audio_wired"):
		return
	button.set_meta("audio_wired", true)
	button.mouse_entered.connect(func(): play("ui.hover"))
	button.pressed.connect(func(): play("ui.click"))


func _ensure_buses() -> void:
	_ensure_bus("SFX", "Master")
	_ensure_bus("Music", "Master")
	_ensure_bus("Ambience", "Master")
	_ensure_bus("UI", "SFX")
	_ensure_bus("Player", "SFX")
	_ensure_bus("Enemies", "SFX")
	_ensure_bus("Impacts", "SFX")


func _ensure_bus(bus_name: String, send_to: String) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index < 0:
		AudioServer.add_bus()
		index = AudioServer.bus_count - 1
		AudioServer.set_bus_name(index, bus_name)
	AudioServer.set_bus_send(index, send_to)


func _load_manifest() -> void:
	if not FileAccess.file_exists(MANIFEST_PATH):
		push_error("Manifesto de áudio ausente: %s" % MANIFEST_PATH)
		return
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	var parsed: Variant = JSON.parse_string(file.get_as_text()) if file != null else null
	if not parsed is Dictionary:
		push_error("Manifesto de áudio inválido: %s" % MANIFEST_PATH)
		return
	_events = parsed.get("events", {})
	_aliases = parsed.get("aliases", {})
	_music_defs = parsed.get("music", {})
	_ambience_defs = parsed.get("ambience", {})


func _apply_profile_mix() -> void:
	if Game.profile != null:
		apply_mix(Game.profile.data.settings)


func apply_mix(settings: Dictionary) -> void:
	_set_bus_linear("Music", float(settings.get("music_volume", 0.8)))
	_set_bus_linear("SFX", float(settings.get("sfx_volume", 0.9)))
	_set_bus_linear("Ambience", float(settings.get("ambience_volume", 0.75)))


func _set_bus_linear(bus_name: String, value: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index < 0:
		return
	var level := clampf(value, 0.0, 1.0)
	AudioServer.set_bus_mute(index, level <= 0.0001)
	AudioServer.set_bus_volume_db(index, linear_to_db(maxf(level, 0.0001)))


func set_context(hero_id: String, stage_id: String) -> void:
	_context_hero = hero_id
	_context_stage = stage_id


func has_event(key: String) -> bool:
	return _events.has(String(_aliases.get(key, key)))


func play(key: String, volume_override_db: float = DEFAULT_OVERRIDE) -> void:
	var resolved := String(_aliases.get(key, key))
	_play_event(resolved, volume_override_db)


func play_weapon(weapon_id: String, fallback: String = "combat.impact") -> void:
	var key := "weapon.%s.fire" % weapon_id
	play(key if has_event(key) else fallback)


func play_hero(hero_id: String = "") -> void:
	var id := hero_id if not hero_id.is_empty() else _context_hero
	var key := "hero.%s.active" % id
	play(key if has_event(key) else "combat.magic")


func play_enemy(enemy_id: String, action: String = "action") -> void:
	var key := "enemy.%s.%s" % [enemy_id, action]
	play(key if has_event(key) else "enemy.%s" % action)


func play_boss(enemy_id: String, cue: String = "arrival") -> void:
	var key := "boss.%s.%s" % [enemy_id, cue]
	play(key if has_event(key) else "boss.arrival")


func _play_event(key: String, volume_override_db: float) -> void:
	if not _events.has(key):
		return
	var definition: Dictionary = _events[key]
	var now := Time.get_ticks_msec()
	var cooldown := int(definition.get("cooldown_ms", 35))
	if now - int(_last_played.get(key, -cooldown)) < cooldown:
		return
	var priority := int(definition.get("priority", 1))
	var voice_index := _pick_voice(priority)
	if voice_index < 0:
		return
	var files: Array = definition.get("files", [])
	if files.is_empty():
		return
	var cursor := int(_variant_cursor.get(key, 0))
	var file_path := String(files[cursor % files.size()])
	_variant_cursor[key] = cursor + 1
	if not ResourceLoader.exists(file_path):
		push_warning("Áudio ausente: %s" % file_path)
		return
	var voice := _voices[voice_index]
	voice.stop()
	voice.stream = load(file_path)
	voice.bus = String(definition.get("bus", "SFX"))
	voice.volume_db = float(definition.get("volume_db", -8.0)) if volume_override_db >= 90.0 else volume_override_db
	var jitter := float(definition.get("pitch_jitter", 0.0))
	voice.pitch_scale = 1.0 + randf_range(-jitter, jitter)
	voice.play()
	_voice_priority[voice_index] = priority
	_voice_started[voice_index] = now
	_last_played[key] = now


func _pick_voice(priority: int) -> int:
	for i in _voices.size():
		if not _voices[i].playing:
			return i
	var candidate := -1
	var oldest := Time.get_ticks_msec()
	for i in _voices.size():
		if _voice_priority[i] <= priority and _voice_started[i] <= oldest:
			candidate = i
			oldest = _voice_started[i]
	return candidate


func start_music(track: String = "") -> void:
	var key := track
	if key.is_empty():
		key = _context_stage if not _context_stage.is_empty() else "menu"
	if key == _music_key and ((_music_a.playing and _music_front_a) or (_music_b.playing and not _music_front_a)):
		return
	if not _music_defs.has(key):
		key = "menu"
	if not _music_defs.has(key):
		return
	var next := _music_b if _music_front_a else _music_a
	var previous := _music_a if _music_front_a else _music_b
	var stream := _load_loop(String(_music_defs[key]))
	if stream == null:
		return
	next.stop()
	next.stream = stream
	next.volume_db = -45.0
	next.play()
	var tween := create_tween().set_parallel(true)
	tween.tween_property(next, "volume_db", -18.0, 0.65)
	if previous.playing:
		tween.tween_property(previous, "volume_db", -45.0, 0.65)
		tween.chain().tween_callback(previous.stop)
	_music_front_a = not _music_front_a
	_music_key = key


func stop_music(fade_seconds: float = 0.35) -> void:
	for player in [_music_a, _music_b]:
		if player != null and player.playing:
			var tween := create_tween()
			tween.tween_property(player, "volume_db", -45.0, fade_seconds)
			tween.tween_callback(player.stop)
	_music_key = ""


func start_ambience(stage_id: String = "") -> void:
	var key := stage_id if not stage_id.is_empty() else _context_stage
	if key == _ambience_key and _ambience.playing:
		return
	if not _ambience_defs.has(key):
		stop_ambience()
		return
	var stream := _load_loop(String(_ambience_defs[key]))
	if stream == null:
		return
	_ambience.stop()
	_ambience.stream = stream
	_ambience.volume_db = -24.0
	_ambience.play()
	_ambience_key = key


func stop_ambience(fade_seconds: float = 0.25) -> void:
	if _ambience != null and _ambience.playing:
		var tween := create_tween()
		tween.tween_property(_ambience, "volume_db", -45.0, fade_seconds)
		tween.tween_callback(_ambience.stop)
	_ambience_key = ""


func _load_loop(file_path: String) -> AudioStream:
	if not ResourceLoader.exists(file_path):
		push_warning("Loop de áudio ausente: %s" % file_path)
		return null
	var stream: AudioStream = load(file_path)
	if stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		if stream.loop_end <= 0:
			var bytes_per_frame := 4 if stream.stereo else 2
			stream.loop_end = int(stream.data.size() / bytes_per_frame)
	return stream

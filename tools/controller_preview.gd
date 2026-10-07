extends Node
## Piloto interativo P068-v03: progresso e ajustes separados do perfil real.
const PILOT_PROFILE := "res://.atena/generated/controller-experience/v01/pilot-profile.json"

func _ready() -> void:
	call_deferred("_start")

func _start() -> void:
	Game._save_path = PILOT_PROFILE
	Game.load_profile()
	Game.touch_preview = false
	Game.profile.data.name = "Piloto Xbox"
	Game.profile.data.welcome_seen = true
	if not Game.profile.data.settings.has("controller"):
		Game.profile.data.settings.controller = {"family": "xbox"}
	Game.ensure_input_actions()
	Game.controls.changed.emit()
	if Playtest._guide_open:
		Playtest._close_guide_modal()
	Game.save()
	Game.logline("Piloto P068-v03; perfil isolado; aceite fisico pendente.")
	var banner := CanvasLayer.new()
	banner.layer = 99
	get_tree().root.add_child(banner)
	var label := Label.new()
	label.text = "P068-v03 · Piloto Xbox · Perfil de teste"
	label.position = Vector2(16, 696)
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 3)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	banner.add_child(label)
	get_tree().change_scene_to_file("res://ui/title.tscn")

extends Node
## SPEC-173 (MEC-066): capturas do Quartel (abas Jogar e Opções) com cada fonte de título disponível.
##   godot --path . res://tools/capture_ui_fonts.tscn -- [pasta]
## Muda o perfil só em memória (sem salvar) e o restaura.

var _dir := "res://.atena/generated/plan-100/capturas-fontes/"

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%s%s_%dx%d.png" % [_dir, name, int(size.x), int(size.y)])

func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	if a.size() > 0:
		_dir = a[0] if a[0].ends_with("/") else a[0] + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	var settings: Dictionary = Game.profile.data.settings
	var original := String(settings.get("ui_font", "padrao"))
	for o in UiFonts.available():
		settings.ui_font = String(o.id)
		for tab in [0, 1]:
			Game.qa_menu_tab = tab
			var menu: Node = load("res://ui/menu.tscn").instantiate()
			add_child(menu)
			await get_tree().create_timer(0.5).timeout
			await _shot("%s_aba%d" % [String(o.id), tab])
			menu.queue_free()
			await get_tree().process_frame
		print("FONTE;%s;faltando=%s" % [String(o.id), UiFonts.missing_glyphs(String(o.id))])
	settings.ui_font = original
	get_tree().quit()

extends Node
## SPEC-132 (MEC-049): prévia do estilo de lettering em Label dinâmico (e das peças de arte, quando existirem).
## godot --path . res://tools/capture_lettering.tscn --resolution 1280x720

func _ready() -> void:
	Playtest.visible = false
	var bg := TextureRect.new()
	bg.texture = load("res://assets/ui/title/title_background.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var rows := [["O Palácio de Zuggtmoy", 56, true], ["Nível 7 — escolha", 34, true], ["Quadro 2 de 4", 22, true], ["Sem gradiente (antes)", 34, false]]
	var y := 40.0
	for row in rows:
		var l := Label.new()
		l.text = row[0]
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.position = Vector2(140, y)
		l.size = Vector2(1000, int(row[1]) * 2)
		Lettering.style(l, int(row[1]), bool(row[2]))
		add_child(l)
		y += int(row[1]) * 2 + 10
	var plate := Lettering.plate_label("placa_titulo_larga", "Placa sem arte (fallback)", 28, Vector2(640, 96))
	plate.position = Vector2(320, y)
	add_child(plate)
	await get_tree().create_timer(0.4).timeout
	await RenderingServer.frame_post_draw
	var dir := "res://.atena/generated/spec-132/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	get_viewport().get_texture().get_image().save_png(dir + "lettering_estilo.png")
	print("capture ok")
	get_tree().quit()

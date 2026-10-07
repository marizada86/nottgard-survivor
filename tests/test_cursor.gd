extends RefCounted
## SPEC-132 (MEC-049): cursor temático. Tolerante à arte ausente: só valida a arte que já existe.

func run() -> Array:
	var out: Array = []
	var table := Data.table("cursor")
	var shape_names := {"arrow": Input.CURSOR_ARROW, "pointing_hand": Input.CURSOR_POINTING_HAND, "cross": Input.CURSOR_CROSS}
	for slot in CursorSkin.SLOTS:
		var entry: Dictionary = table.get(slot, {})
		if entry.is_empty():
			out.append("data/cursor.json sem a entrada %s" % slot)
			continue
		if shape_names.get(String(entry.get("shape", "")), -1) != CursorSkin.SLOTS[slot]:
			out.append("%s: forma '%s' não bate com o mapa do CursorSkin" % [slot, entry.get("shape", "")])
		var size: Array = entry.get("size", [0, 0])
		var hot := CursorSkin.hotspot_of(slot)
		if int(size[0]) <= 0 or maxi(int(size[0]), int(size[1])) > CursorSkin.MAX_SIZE:
			out.append("%s: tamanho %s fora de 1..%d" % [slot, size, CursorSkin.MAX_SIZE])
		if hot.x < 0 or hot.y < 0 or hot.x >= int(size[0]) or hot.y >= int(size[1]):
			out.append("%s: hotspot %s fora da imagem %s" % [slot, hot, size])
		if ResourceLoader.exists(CursorSkin.path_of(slot)):
			var tex := load(CursorSkin.path_of(slot)) as Texture2D
			if tex == null:
				out.append("%s: PNG não carrega" % slot)
			elif tex.get_width() != int(size[0]) or tex.get_height() != int(size[1]):
				out.append("%s: PNG %dx%d, esperado %s" % [slot, tex.get_width(), tex.get_height(), size])
	if CursorSkin.hotspot_of("cursor_mira") != Vector2(20, 20) and not ResourceLoader.exists(CursorSkin.path_of("cursor_mira")):
		out.append("cursor_mira: hotspot provisório deve ser o centro (20, 20)")

	# Forma da run: mira só com mouse, sem modal e com arte da mira.
	CursorSkin._applied.clear()
	if CursorSkin.run_shape(true, false) != Input.CURSOR_ARROW:
		out.append("sem arte da mira, a run não pode trocar a forma")
	CursorSkin._applied[Input.CURSOR_CROSS] = true
	if CursorSkin.run_shape(true, false) != Input.CURSOR_CROSS:
		out.append("mira por mouse sem modal deveria usar CROSS")
	if CursorSkin.run_shape(false, false) != Input.CURSOR_ARROW:
		out.append("mira AUTO deveria usar ARROW")
	if CursorSkin.run_shape(true, true) != Input.CURSOR_ARROW:
		out.append("com modal aberto deveria voltar a ARROW")

	# Mão nos botões só com a arte da mão.
	var button := Button.new()
	CursorSkin._applied.clear()
	CursorSkin._on_node_added(button)
	if button.mouse_default_cursor_shape != Control.CURSOR_ARROW:
		out.append("botão ganhou mão sem a arte")
	CursorSkin._applied[Input.CURSOR_POINTING_HAND] = true
	CursorSkin._on_node_added(button)
	if button.mouse_default_cursor_shape != Control.CURSOR_POINTING_HAND:
		out.append("botão não ganhou a mão com a arte")
	var custom := Button.new()
	custom.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	CursorSkin._on_node_added(custom)
	if custom.mouse_default_cursor_shape != Control.CURSOR_FORBIDDEN:
		out.append("forma própria do botão foi sobrescrita")
	button.free()
	custom.free()
	CursorSkin.reset()
	CursorSkin.apply()  # restaura o estado real
	return out

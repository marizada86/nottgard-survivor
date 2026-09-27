extends Node
## Captura reprodutível do piloto. Uso: godot --headless --path . res://tools/terrain_pilot_shot.tscn -- <saida.png>

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var output_path := String(args[0]) if not args.is_empty() else "terrain-pilot.png"
	add_child(load("res://tools/terrain_pilot.tscn").instantiate())
	await get_tree().process_frame
	await get_tree().process_frame
	var viewport_texture := get_viewport().get_texture()
	if viewport_texture == null:
		print("captura do piloto indisponível sem viewport de renderização")
		get_tree().quit()
		return
	var image := viewport_texture.get_image()
	if image == null:
		print("captura do piloto indisponível sem imagem de viewport")
		get_tree().quit()
		return
	var status := image.save_png(output_path)
	if status != OK:
		push_error("Não foi possível capturar o piloto de terreno: %s" % output_path)
	get_tree().quit(0 if status == OK else 1)

extends SceneTree
## Auditoria de opacidade (BUG-002): fração de pixels visíveis que são sólidos (alfa >= 0.9) e alfa médio.
## Sprites com a mesma falha do Leoric/Zumbi antigos (silhueta quase transparente com pixels soltos) ficam com solidez baixa.
## Uso: godot --headless --path . -s tools/audit_alpha_solidity.gd -- [pasta res://...]

func _scan(dir: String, rows: Array) -> void:
	var d := DirAccess.open(dir)
	if d == null:
		return
	for sub in d.get_directories():
		_scan(dir.path_join(sub), rows)
	for f in d.get_files():
		if not f.ends_with(".png"):
			continue
		var path := dir.path_join(f)
		var img := Image.load_from_file(ProjectSettings.globalize_path(path))
		if img == null:
			continue
		var visible := 0
		var solid := 0
		var sum := 0.0
		for y in range(0, img.get_height(), 2):
			for x in range(0, img.get_width(), 2):
				var a := img.get_pixel(x, y).a
				if a > 0.04:
					visible += 1
					sum += a
					if a >= 0.9:
						solid += 1
		if visible > 0:
			rows.append({"path": path, "solid": float(solid) / float(visible), "mean": sum / float(visible), "visible": visible})

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var rows: Array = []
	for root in (args if args.size() > 0 else ["res://assets/enemies", "res://assets/animations", "res://assets/heroes"]):
		_scan(root, rows)
	rows.sort_custom(func(a, b): return a.solid < b.solid)
	for r in rows.slice(0, 25):
		print("%.3f solido | alfa medio %.3f | %s" % [r.solid, r.mean, String(r.path).trim_prefix("res://assets/")])
	print("total de imagens: %d" % rows.size())
	quit()

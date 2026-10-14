extends SceneTree
## SPEC-176 (M1, S-001/S-004): inventario e regua das tiras dos herois, somente leitura.
## godot --headless --path . -s tools/m1_inventory.gd
## Saida: .atena/generated/m1-movimento/inventario.csv e reguas.csv (relativo ao projeto).
##
## Uma linha por heroi e tira: quadros, celula, caixa de alfa por quadro (altura, base, largura), margem minima de borda.
## A regua de cada heroi e o idle dele mesmo (altura, base e largura medianas).

const SEQUENCES := ["idle", "move", "move_n", "move_ne", "move_e", "move_se", "move_s", "move_sw", "move_w", "move_nw", "attack", "active", "death"]
const FRAMES := {"idle": 4, "move": 6, "attack": 4, "active": 6, "death": 6}
const ALPHA := 0.10
const SPEED_PX := 190.0
const WALK_FPS := 10.0
const WALK_FRAMES := 6

func _initialize() -> void:
	var hero_script: Script = load("res://ui/hero_view.gd")
	var out_dir := ProjectSettings.globalize_path("res://.atena/generated/m1-movimento")
	DirAccess.make_dir_recursive_absolute(out_dir)
	var inv: Array[String] = ["hero,sequence,exists,cell_w,cell_h,frames,median_w,median_h,height_spread_pct,median_bottom,bottom_spread,min_edge_margin,empty_frames,mirrored_in_runtime"]
	var rul: Array[String] = ["hero,display_h_px,idle_art_h,feet_y,scale,idle_median_w,idle_bottom,cycle_screen_px_10fps,step_screen_px_10fps,step_art_px_10fps,step_to_height_10fps,fps_for_step_0_5h,fps_for_step_0_6h,source_cell"]
	var dir := DirAccess.open("res://assets/animations/heroes")
	var heroes: Array = dir.get_directories()
	heroes.sort()
	for hero in heroes:
		var cell: Vector2i = hero_script.HERO_SOURCE_CELL.get(StringName(hero), Vector2i(256, 384))
		var idle_w := 0.0
		var idle_h := 0.0
		var idle_bottom := 0.0
		for seq in SEQUENCES:
			var path := "res://assets/animations/heroes/%s/%s.png" % [hero, seq]
			var mirrored := false
			if not FileAccess.file_exists(ProjectSettings.globalize_path(path)):
				inv.append("%s,%s,no,,,,,,,,,,,%s" % [hero, seq, str(seq in ["move_w", "move_sw", "move_nw"])])
				continue
			var image := Image.new()
			if image.load(ProjectSettings.globalize_path(path)) != OK:
				inv.append("%s,%s,invalid,,,,,,,,,,," % [hero, seq])
				continue
			image.convert(Image.FORMAT_RGBA8)
			var frames: int = image.get_width() / cell.x
			var ws: Array[float] = []
			var hs: Array[float] = []
			var bs: Array[float] = []
			var min_margin := 9999
			var empty := 0
			for i in frames:
				var b := _bounds(image, i, cell)
				if b.size == Vector2i.ZERO:
					empty += 1
					continue
				ws.append(b.size.x)
				hs.append(b.size.y)
				bs.append(b.end.y)
				var left := b.position.x
				var right := cell.x - b.end.x
				var top := b.position.y
				var bottom := cell.y - b.end.y
				min_margin = mini(min_margin, mini(mini(left, right), mini(top, bottom)))
			var mh := _median(hs)
			var spread: float = 0.0 if hs.is_empty() else (float(hs.max()) - float(hs.min())) / maxf(mh, 1.0) * 100.0
			var bsp: float = 0.0 if bs.is_empty() else float(bs.max()) - float(bs.min())
			if seq == "idle":
				idle_w = _median(ws)
				idle_h = mh
				idle_bottom = _median(bs)
			inv.append("%s,%s,yes,%d,%d,%d,%.0f,%.0f,%.1f,%.0f,%.0f,%d,%d,%s" % [hero, seq, cell.x, cell.y, frames, _median(ws), mh, spread, _median(bs), bsp, min_margin if min_margin != 9999 else -1, empty, str(seq in ["move_w", "move_sw", "move_nw"])])
		var display_h: float = float(hero_script.HERO_DISPLAY_HEIGHT.get(StringName(hero), 0.0))
		var art_h: float = float(hero_script.HERO_IDLE_ART_HEIGHT.get(StringName(hero), 1.0))
		var feet: float = float(hero_script.HERO_FEET_Y.get(StringName(hero), 0.0))
		var scale := display_h / art_h
		var speed := SPEED_PX * (0.9 if hero == "korrak" else 1.0)
		var cycle_px := speed * WALK_FRAMES / WALK_FPS
		var step_screen := cycle_px / 2.0
		var step_art := step_screen / maxf(scale, 0.001)
		var fps_05 := speed * WALK_FRAMES / (2.0 * 0.5 * display_h) if display_h > 0.0 else 0.0
		var fps_06 := speed * WALK_FRAMES / (2.0 * 0.6 * display_h) if display_h > 0.0 else 0.0
		rul.append("%s,%.0f,%.0f,%.0f,%.3f,%.0f,%.0f,%.0f,%.0f,%.0f,%.2f,%.1f,%.1f,%dx%d" % [hero, display_h, art_h, feet, scale, idle_w, idle_bottom, cycle_px, step_screen, step_art, step_art / maxf(art_h, 1.0), fps_05, fps_06, cell.x, cell.y])
	_write(out_dir + "/inventario.csv", "\n".join(inv) + "\n")
	_write(out_dir + "/reguas.csv", "\n".join(rul) + "\n")
	print("\n".join(rul))
	quit(0)

func _bounds(image: Image, index: int, cell: Vector2i) -> Rect2i:
	var x0 := index * cell.x
	var min_x := cell.x
	var min_y := cell.y
	var max_x := -1
	var max_y := -1
	for y in cell.y:
		for x in cell.x:
			if image.get_pixel(x0 + x, y).a > ALPHA:
				min_x = mini(min_x, x)
				max_x = maxi(max_x, x)
				min_y = mini(min_y, y)
				max_y = maxi(max_y, y)
	if max_x < 0:
		return Rect2i()
	return Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)

func _median(values: Array[float]) -> float:
	if values.is_empty():
		return 0.0
	var copy := values.duplicate()
	copy.sort()
	return copy[copy.size() / 2]

func _write(path: String, text: String) -> void:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("sem escrita: %s" % path)
		return
	f.store_string(text)
	f.close()

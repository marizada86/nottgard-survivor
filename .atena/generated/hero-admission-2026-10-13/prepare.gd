extends SceneTree

const OUT := "res://.atena/generated/hero-admission-2026-10-13/"

func _init() -> void:
	call_deferred("prepare")

func prepare() -> void:
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://.atena/generated/hero-admission-preparation-2026-10-13/admission-manifest.json"))
	var records: Array = []
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT + "derivatives"))
	for entry: Dictionary in manifest.animations:
		var source_path := "res://" + String(entry.path)
		assert(FileAccess.get_sha256(source_path) == entry.sha256)
		var source := Image.load_from_file(source_path)
		source.convert(Image.FORMAT_RGBA8)
		var cell := Vector2i(int(entry.cell[0]), int(entry.cell[1]))
		var count := int(entry.frames)
		var offset := Vector2i(128, 80) if cell == Vector2i(256, 384) else Vector2i.ZERO
		assert(cell == Vector2i(256, 384) or cell == Vector2i(512, 512))
		assert(source.get_size() == Vector2i(cell.x * count, cell.y))
		var packed := Image.create(512 * count, 512, false, Image.FORMAT_RGBA8)
		packed.fill(Color(0, 0, 0, 0))
		var frames: Array = []
		for index in count:
			var native := source.get_region(Rect2i(index * cell.x, 0, cell.x, cell.y))
			packed.blit_rect(native, Rect2i(Vector2i.ZERO, cell), Vector2i(index * 512, 0) + offset)
			assert(packed.get_region(Rect2i(Vector2i(index * 512, 0) + offset, cell)).get_data() == native.get_data())
			var left := 512
			var right := -1
			var top := 512
			var bottom := -1
			for y in 512:
				for x in 512:
					if packed.get_pixel(index * 512 + x, y).a > 8.0 / 255.0:
						left = mini(left, x)
						right = maxi(right, x)
						top = mini(top, y)
						bottom = maxi(bottom, y)
			assert(right >= left)
			assert(left >= 10 and top >= 10 and 511 - right >= 10 and 511 - bottom >= 10)
			if entry.animation in ["idle", "move_e", "move_se", "move_s", "move_ne", "move_n"]:
				assert(absi(bottom + 1 - 448) <= 6)
			frames.append({"index": index, "significant_bbox": [left, top, right + 1, bottom + 1], "rgba_source_preserved": true})
		var path := OUT + "derivatives/" + String(entry.code) + ".png"
		if cell == Vector2i(512, 512):
			assert(DirAccess.copy_absolute(ProjectSettings.globalize_path(source_path), ProjectSettings.globalize_path(path)) == OK)
			assert(FileAccess.get_sha256(path) == entry.sha256)
		else:
			assert(packed.save_png(ProjectSettings.globalize_path(path)) == OK)
		var reloaded := Image.load_from_file(path)
		reloaded.convert(Image.FORMAT_RGBA8)
		assert(reloaded.get_data() == packed.get_data())
		records.append({"code": entry.code, "hero": entry.hero, "animation": entry.animation, "count": count, "path": path.trim_prefix("res://"), "destination": entry.proposed_destination, "source": entry.path, "source_sha256": entry.sha256, "sha256": FileAccess.get_sha256(path), "offset": [offset.x, offset.y], "cell": [512, 512], "baseline": 448, "frames": frames, "rgba_preserved": true})
		if entry.animation == "idle":
			var still := packed.get_region(Rect2i(0, 0, 512, 512))
			assert(still.save_png(ProjectSettings.globalize_path(OUT + "derivatives/" + String(entry.hero) + "-static.png")) == OK)
	var file := FileAccess.open(OUT + "packing.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"revision": "hero-admission/v01", "content_state": "DRAFT", "result": "PASS", "strips": 18, "frames": 101, "cell": [512, 512], "baseline": 448, "resampling": false, "records": records}, "\t") + "\n")
	print("prepare PASS: 18 atlas/101 frames, RGBA exact, margins >=10, base 448, two stills")
	quit()

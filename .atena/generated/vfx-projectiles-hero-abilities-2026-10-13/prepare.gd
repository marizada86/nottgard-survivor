extends SceneTree
## S-001 do SPEC-121/vfx-projectiles-and-hero-abilities/v01: auditoria tecnica somente leitura das fontes
## nativas, miniaturas de 256 px e pranchas de revisao. Nenhuma fonte e alterada; nada entra em assets/.

const ROOT := "res://.atena/generated/vfx-projectiles-hero-abilities-2026-10-13/"
const PREVIEW := 256

func _initialize() -> void:
	var base := ProjectSettings.globalize_path(ROOT)
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(base + "manifest.json"))
	DirAccess.make_dir_recursive_absolute(base + "review/previews")
	DirAccess.make_dir_recursive_absolute(base + "review/sheets")
	var audit := {"revision": manifest.revision, "effects": []}
	for group in ["A", "B"]:
		for effect in manifest.groups[group]:
			var rec := _process_effect(base, group, effect)
			audit.effects.append(rec)
			print("%s %-28s frames=%d ok=%s flags=%s" % [group, effect.id, effect.frames.size(), rec.ok, JSON.stringify(rec.flags)])
	var f := FileAccess.open(base + "audit.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(audit, "  "))
	f.close()
	quit(0)

func _process_effect(base: String, group: String, effect: Dictionary) -> Dictionary:
	var frames: Array = []
	var flags: Array = []
	var cols := 4 if group == "A" else 6
	var rows := int(ceil(effect.frames.size() / float(cols)))
	var sheet := Image.create(cols * PREVIEW, rows * PREVIEW, false, Image.FORMAT_RGBA8)
	sheet.fill(Color.BLACK)
	var native_size := Vector2i.ZERO
	var index := 0
	for fr in effect.frames:
		var img := Image.load_from_file(base + fr.file)
		if img == null or img.is_empty():
			flags.append("LOAD_FAIL:" + fr.code)
			index += 1
			continue
		img.convert(Image.FORMAT_RGBA8)
		var size := img.get_size()
		if native_size == Vector2i.ZERO:
			native_size = size
		elif size != native_size:
			flags.append("SIZE_MISMATCH:" + fr.code)
		var stat := _stats(img)
		var sha := FileAccess.get_sha256(base + fr.file)
		if sha != String(fr.sha256):
			flags.append("SHA_MISMATCH:" + fr.code)
		if stat.edge_max > 12:
			flags.append("EDGE_LIGHT:%s=%d" % [fr.code, stat.edge_max])
		if stat.peak_lum < 200:
			flags.append("DIM_PEAK:%s=%d" % [fr.code, stat.peak_lum])
		var prev := img.duplicate() as Image
		prev.resize(PREVIEW, PREVIEW, Image.INTERPOLATE_LANCZOS)
		prev.save_png(base + "review/previews/%s_%s.png" % [effect.id, fr.code])
		sheet.blit_rect(prev, Rect2i(0, 0, PREVIEW, PREVIEW), Vector2i((index % cols) * PREVIEW, (index / cols) * PREVIEW))
		frames.append({"code": fr.code, "version": fr.version, "size": [size.x, size.y], "sha256": sha, "edge_max": stat.edge_max,
			"mean_lum": snappedf(stat.mean_lum, 0.01), "peak_lum": stat.peak_lum, "bbox_lum_gt12": stat.bbox, "lum_centroid": stat.centroid})
		index += 1
	sheet.save_png(base + "review/sheets/%s.png" % effect.id)
	return {"group": group, "id": effect.id, "title": effect.title, "native_size": [native_size.x, native_size.y], "ok": flags.is_empty(), "flags": flags, "frames": frames}

func _stats(img: Image) -> Dictionary:
	var size := img.get_size()
	var edge := 0
	for x in size.x:
		edge = maxi(edge, _chan(img.get_pixel(x, 0)))
		edge = maxi(edge, _chan(img.get_pixel(x, size.y - 1)))
	for y in size.y:
		edge = maxi(edge, _chan(img.get_pixel(0, y)))
		edge = maxi(edge, _chan(img.get_pixel(size.x - 1, y)))
	var small := img.duplicate() as Image
	small.resize(size.x / 4, size.y / 4, Image.INTERPOLATE_BILINEAR)
	var w := small.get_width()
	var h := small.get_height()
	var sum := 0.0
	var peak := 0
	var minx := w
	var miny := h
	var maxx := -1
	var maxy := -1
	var cx := 0.0
	var cy := 0.0
	var cw := 0.0
	for y in h:
		for x in w:
			var c := small.get_pixel(x, y)
			var l := (0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b) * 255.0
			sum += l
			if l > peak:
				peak = int(l)
			if l > 12.0:
				minx = mini(minx, x)
				maxx = maxi(maxx, x)
				miny = mini(miny, y)
				maxy = maxi(maxy, y)
			if l > 180.0:
				var wgt := (l - 180.0) * (l - 180.0)
				cx += x * wgt
				cy += y * wgt
				cw += wgt
	var bbox := [] if maxx < 0 else [minx * 4, miny * 4, (maxx + 1) * 4, (maxy + 1) * 4]
	var centroid := [] if cw <= 0.0 else [snappedf(cx / cw * 4.0, 0.1), snappedf(cy / cw * 4.0, 0.1)]
	return {"edge_max": edge, "mean_lum": sum / float(w * h), "peak_lum": peak, "bbox": bbox, "centroid": centroid}

func _chan(c: Color) -> int:
	return int(maxf(c.r, maxf(c.g, c.b)) * 255.0)

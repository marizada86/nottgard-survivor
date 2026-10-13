extends SceneTree

func _init() -> void:
	var project_root := OS.get_cmdline_user_args()[0]
	var package_root := project_root.path_join(".atena/generated/fila026-l01-2026-10-11")
	DirAccess.make_dir_recursive_absolute(package_root.path_join("prepared"))
	DirAccess.make_dir_recursive_absolute(package_root.path_join("previews"))
	var results: Array = []
	for revision_value in ["v01", "v02"]:
		var revision: String = String(revision_value)
		var source_path := project_root.path_join(".atena/generated/art-candidates/lettering/l01_" + revision + ".png")
		var original := Image.load_from_file(source_path)
		assert(original != null and not original.is_empty())
		var keyed: Image = original.duplicate()
		keyed.convert(Image.FORMAT_RGBA8)
		var removed := 0
		for y in range(keyed.get_height()):
			for x in range(keyed.get_width()):
				var color := keyed.get_pixel(x, y)
				var red := roundi(color.r * 255.0)
				var green := roundi(color.g * 255.0)
				var blue := roundi(color.b * 255.0)
				if green > 90 and blue > 90 and green-red > 25 and blue-red > 25 and absi(green-blue) < 65:
					keyed.set_pixel(x, y, Color(0, 0, 0, 0))
					removed += 1
		var bounds := keyed.get_used_rect()
		assert(bounds.has_area())
		var padded := bounds.grow(4).intersection(Rect2i(Vector2i.ZERO, keyed.get_size()))
		var cropped := keyed.get_region(padded)
		var native_path := "prepared/L01_" + revision + "_native.png"
		assert(cropped.save_png(package_root.path_join(native_path)) == OK)
		var final_image := fit_image(cropped, Vector2i(1100, 176))
		var final_path := "prepared/L01_" + revision + ".png"
		assert(final_image.save_png(package_root.path_join(final_path)) == OK)
		var small := fit_image(cropped, Vector2i(300, 48))
		var small_path := "previews/L01_" + revision + "_300x48.png"
		assert(small.save_png(package_root.path_join(small_path)) == OK)
		var title := Image.load_from_file(project_root.path_join("assets/ui/title/title_background.png"))
		title.resize(1280, 720, Image.INTERPOLATE_LANCZOS)
		title.convert(Image.FORMAT_RGBA8)
		title.blend_rect(final_image, Rect2i(Vector2i.ZERO, final_image.get_size()), Vector2i((1280-final_image.get_width())/2, 24))
		var title_path := "previews/L01_" + revision + "_title_1280x720.png"
		assert(title.save_png(package_root.path_join(title_path)) == OK)
		results.append({"revision": revision, "source": source_path, "source_size": [original.get_width(), original.get_height()], "source_bbox": [bounds.position.x, bounds.position.y, bounds.end.x, bounds.end.y], "padded_crop": [padded.position.x, padded.position.y, padded.end.x, padded.end.y], "key_pixels_removed": removed, "native": native_path, "final": final_path, "final_size": [final_image.get_width(), final_image.get_height()], "small": small_path, "small_size": [small.get_width(), small.get_height()], "title": title_path, "interpolation": "nearest", "content_state": "DRAFT", "runtime_admission": false})
	var file := FileAccess.open(package_root.path_join("preview-metadata.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"records": results}, "\t"))
	file.close()
	print(JSON.stringify({"previewed_revisions": 2, "runtime_admission": false, "outputs": results}))
	quit()

func fit_image(source: Image, limit: Vector2i) -> Image:
	var factor := minf(float(limit.x)/source.get_width(), float(limit.y)/source.get_height())
	var fitted: Image = source.duplicate()
	var size := Vector2i(maxi(1, floori(source.get_width()*factor)), maxi(1, floori(source.get_height()*factor)))
	fitted.resize(size.x, size.y, Image.INTERPOLATE_NEAREST)
	return fitted

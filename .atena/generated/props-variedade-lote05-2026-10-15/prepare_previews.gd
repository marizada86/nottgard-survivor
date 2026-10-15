extends SceneTree

func framed(image: Image, size: int) -> Image:
	var crop := image.get_region(image.get_used_rect())
	var scale := minf(float(size - 32) / crop.get_width(), float(size - 32) / crop.get_height())
	crop.resize(maxi(1, roundi(crop.get_width() * scale)), maxi(1, roundi(crop.get_height() * scale)), Image.INTERPOLATE_NEAREST)
	var canvas := Image.create(size, size, false, Image.FORMAT_RGBA8)
	canvas.fill(Color.TRANSPARENT)
	canvas.blit_rect(crop, Rect2i(Vector2i.ZERO, crop.get_size()), Vector2i((size - crop.get_width()) / 2, size - 16 - crop.get_height()))
	return canvas

func _initialize() -> void:
	var batch_root := OS.get_cmdline_user_args()[0]
	var repo := batch_root.get_base_dir().get_base_dir().get_base_dir()
	DirAccess.make_dir_recursive_absolute(batch_root.path_join("previews"))
	DirAccess.make_dir_recursive_absolute(batch_root.path_join("references"))
	var jobs: Array = JSON.parse_string(FileAccess.get_file_as_string(batch_root.path_join("jobs.json")))
	var sheet := Image.create(1024, 512, false, Image.FORMAT_RGBA8)
	sheet.fill(Color("1c2330"))
	var records: Array = []
	var index := 0
	for job: Dictionary in jobs:
		var native := Image.load_from_file(batch_root.path_join(job.source))
		native.convert(Image.FORMAT_RGBA8)
		var bounds := native.get_used_rect()
		# Preserve alpha and every source pixel in this technical review copy.
		var preview := framed(native, 256)
		preview.save_png(batch_root.path_join("previews/" + job.id + "-256.png"))
		for size in [64, 128]:
			var smaller := preview.duplicate() as Image
			smaller.resize(size, size, Image.INTERPOLATE_NEAREST)
			smaller.save_png(batch_root.path_join("previews/" + job.id + "-" + str(size) + ".png"))
		var ref_path: String = repo.path_join(job.reference)
		DirAccess.copy_absolute(ref_path, batch_root.path_join("references/" + job.id + ".png"))
		var reference := Image.load_from_file(ref_path)
		reference.convert(Image.FORMAT_RGBA8)
		var ref_preview := framed(reference, 256)
		ref_preview.save_png(batch_root.path_join("previews/" + job.id + "-reference-256.png"))
		sheet.blend_rect(preview, Rect2i(Vector2i.ZERO, preview.get_size()), Vector2i(index % 4 * 256, index / 4 * 256))
		records.append({"id": job.id, "crop_alpha_nonzero": [bounds.position.x, bounds.position.y, bounds.size.x, bounds.size.y], "preview": [256, 256], "minimum_margin_after_fit": 16, "base_y": 240, "method": "all native alpha retained; bbox crop then uniform nearest resize; no repaint, threshold or edge cleanup", "runtime_admission": false})
		index += 1
	sheet.save_png(batch_root.path_join("previews/contact-sheet.png"))
	var record_file := FileAccess.open(batch_root.path_join("previews/preparation.json"), FileAccess.WRITE)
	record_file.store_string(JSON.stringify(records, "  "))
	print("Prepared 8 candidate props, references and review sheet")
	quit()

extends SceneTree

func _init() -> void:
	var project_root: String = OS.get_cmdline_user_args()[0]
	var package_root := project_root.path_join(".atena/generated/fila026-remaining-2026-10-11")
	DirAccess.make_dir_recursive_absolute(package_root.path_join("previews"))
	var jobs: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package_root.path_join("jobs.json")))
	var normalized: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package_root.path_join("normalization.json")))
	var capture_path := ".atena/generated/ficha-c-integration/v01/desktop_heroi_durvall.png"
	var capture := Image.load_from_file(project_root.path_join(capture_path))
	capture.convert(Image.FORMAT_RGBA8)
	assert(capture.get_size() == Vector2i(1280,720))
	var compositions: Array = []
	for record in normalized.records:
		var job: Dictionary = {}
		for candidate in jobs.jobs:
			if candidate.code == record.code:
				job = candidate
		var asset := Image.load_from_file(package_root.path_join(record.final))
		var context: Image = capture.duplicate()
		var base_source := capture_path
		var position := Vector2i((1280-asset.get_width())/2,90)
		if job.kind == "lettering":
			base_source = job.background
			context = Image.load_from_file(project_root.path_join(base_source))
			context.resize(1280,720,Image.INTERPOLATE_LANCZOS)
			context.convert(Image.FORMAT_RGBA8)
			if job.code == "L05":
				var frame: Image = context.duplicate()
				context = Image.load_from_file(project_root.path_join("assets/ui/title/title_background.png"))
				context.resize(1280,720,Image.INTERPOLATE_LANCZOS)
				context.convert(Image.FORMAT_RGBA8)
				context.blend_rect(frame,Rect2i(Vector2i.ZERO,frame.get_size()),Vector2i.ZERO)
			position = Vector2i((1280-asset.get_width())/2,120)
		elif job.kind == "cursor":
			var anchor := Vector2i(1160,125) if job.code == "C01" else Vector2i(570,165)
			if job.code == "C03":
				anchor = Vector2i(275,215)
			position = anchor-Vector2i(int(record.hotspot[0]),int(record.hotspot[1]))
		context.blend_rect(asset,Rect2i(Vector2i.ZERO,asset.get_size()),position)
		var out_path: String = "previews/"+String(job.code)+"_context_1280x720.png"
		assert(context.save_png(package_root.path_join(out_path)) == OK)
		compositions.append({"code":job.code,"path":out_path,"base":base_source,"position":[position.x,position.y],"kind":"illustrative_composite_not_runtime_integration"})
	for tone in ["dark","light"]:
		var surface := Image.create(360,96,false,Image.FORMAT_RGBA8)
		surface.fill(Color("171923") if tone == "dark" else Color("eee5d0"))
		var column := 0
		for record in normalized.records:
			if record.kind != "cursor":
				continue
			var cursor := Image.load_from_file(package_root.path_join(record.final))
			var anchor := Vector2i(60+column*120,48)
			var hotspot := Vector2i(int(record.hotspot[0]),int(record.hotspot[1]))
			surface.blend_rect(cursor,Rect2i(Vector2i.ZERO,cursor.get_size()),anchor-hotspot)
			column += 1
		assert(surface.save_png(package_root.path_join("previews/cursors_"+String(tone)+".png")) == OK)
	var file := FileAccess.open(package_root.path_join("compositions.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"records":compositions},"\t"))
	file.close()
	print(JSON.stringify({"context_previews":compositions.size(),"cursor_tone_previews":2}))
	quit()

extends SceneTree

const OUT := "res://.atena/generated/assets-l002-admission-2026-10-14/"

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT+"normalized"))
	var receipt: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(OUT+"authorization.json"))
	var rows: Array = []
	for family in receipt.families:
		var atlas := Image.create(1536,256,false,Image.FORMAT_RGBA8)
		atlas.fill(Color(1,1,1,0))
		for index in 6:
			var source: Dictionary = family.sources[index]
			var path := "res://"+String(source.path)
			assert(FileAccess.get_sha256(path)==source.sha256)
			var original := Image.load_from_file(path)
			var normalized := original.duplicate() as Image
			normalized.resize(1024,1024,Image.INTERPOLATE_LANCZOS)
			assert(normalized.save_png(OUT+"normalized/"+String(source.code)+".png")==OK)
			var small := original.duplicate() as Image
			var side := int(family.content_side)
			var pad := (256-side)/2
			small.resize(side,side,Image.INTERPOLATE_LANCZOS)
			for y in side:
				for x in side:
					var p := small.get_pixel(x,y)
					var light := p.r*0.2126+p.g*0.7152+p.b*0.0722
					atlas.set_pixel(index*256+x+pad,y+pad,Color(1,1,1,0 if light<=2.0/255.0 else light))
			rows.append({"code":source.code,"version":source.version,"source":source.path,"sha256":source.sha256,"atlas":family.name,"offset":[index*256,0]})
		assert(atlas.save_png(OUT+String(family.name)+".png")==OK)
	var file := FileAccess.open(OUT+"packing.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"revision":"assets-l002-admission/v01","records":rows,"atlas_size":[1536,256],"cell":[256,256],"canvas_center":[128,128],"filter":"Godot Lanczos native->1024 audit and native->256 runtime","alpha":"Rec709 luminance; <=2/255zero","rgb":"white","native_bytes_preserved":true},"\t")+"\n")
	print("prepare PASS: 42 normalized sources, seven six-cell atlases")
	quit()

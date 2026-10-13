extends SceneTree

func _init() -> void:
	var project_root: String = OS.get_cmdline_user_args()[0]
	var package_root := project_root.path_join(".atena/generated/fila026-remaining-2026-10-11")
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package_root.path_join("jobs.json")))
	DirAccess.make_dir_recursive_absolute(package_root.path_join("prepared"))
	DirAccess.make_dir_recursive_absolute(package_root.path_join("native"))
	var results: Array = []
	for job in data.jobs:
		assert(job.status == "GENERATED")
		var code: String = job.code
		var source := Image.load_from_file(package_root.path_join(job.source))
		var keyed: Image = source.duplicate()
		keyed.convert(Image.FORMAT_RGBA8)
		var key_count := 0
		for y in range(keyed.get_height()):
			for x in range(keyed.get_width()):
				var color := keyed.get_pixel(x, y)
				var red := roundi(color.r*255.0)
				var green := roundi(color.g*255.0)
				var blue := roundi(color.b*255.0)
				if red > 210 and blue > 210 and green < 80 and red-green > 130 and blue-green > 130:
					keyed.set_pixel(x,y,Color(0,0,0,0))
					key_count += 1
		var eroded: Image = keyed.duplicate()
		var eroded_count := 0
		for y in range(1,keyed.get_height()-1):
			for x in range(1,keyed.get_width()-1):
				if keyed.get_pixel(x,y).a == 0:
					continue
				if keyed.get_pixel(x-1,y).a == 0 or keyed.get_pixel(x+1,y).a == 0 or keyed.get_pixel(x,y-1).a == 0 or keyed.get_pixel(x,y+1).a == 0:
					eroded.set_pixel(x,y,Color(0,0,0,0))
					eroded_count += 1
		var bbox := eroded.get_used_rect()
		var cropped := eroded.get_region(bbox)
		var native_path := "native/"+code+"_v01.png"
		assert(cropped.save_png(package_root.path_join(native_path)) == OK)
		var limit := Vector2i(int(job.target[0]),int(job.target[1]))
		var final_image: Image
		var method := "proportional-nearest"
		var mapping: Dictionary = {}
		if job.kind == "plate":
			var scaled: Image = cropped.duplicate()
			var scale := float(limit.y)/cropped.get_height()
			scaled.resize(floori(cropped.get_width()*scale),limit.y,Image.INTERPOLATE_NEAREST)
			var left := int(job.slices[0])
			var right := int(job.slices[1])
			assert(scaled.get_width() > left+right)
			final_image = Image.create(limit.x,limit.y,false,Image.FORMAT_RGBA8)
			final_image.fill(Color(0,0,0,0))
			final_image.blit_rect(scaled,Rect2i(0,0,left,limit.y),Vector2i.ZERO)
			final_image.blit_rect(scaled,Rect2i(scaled.get_width()-right,0,right,limit.y),Vector2i(limit.x-right,0))
			var center_x := scaled.get_width()/2
			for y in range(limit.y):
				var sample := scaled.get_pixel(center_x,y)
				for x in range(left,limit.x-right):
					final_image.set_pixel(x,y,sample)
			method = "height-proportional-endcaps-native-center-column-tiled"
			mapping = {"scaled_source_size":[scaled.get_width(),scaled.get_height()],"left":left,"right":right,"center_sample_x":center_x,"slices":job.slices}
		elif job.kind == "cursor":
			var intermediate: Image = eroded.duplicate()
			intermediate.resize(limit.x*4,limit.y*4,Image.INTERPOLATE_NEAREST)
			var four_x_path := "prepared/"+code+"_v01_4x.png"
			assert(intermediate.save_png(package_root.path_join(four_x_path)) == OK)
			final_image = intermediate.duplicate()
			final_image.resize(limit.x,limit.y,Image.INTERPOLATE_NEAREST)
			method = "square-canvas-nearest-to-4x-then-final"
			mapping = {"four_x":four_x_path}
			if code == "C03":
				var quadrant_source: Image = final_image.duplicate()
				var half := limit.x/2
				for y in range(half):
					for x in range(half):
						var sample := quadrant_source.get_pixel(x,y)
						final_image.set_pixel(limit.x-1-y,x,sample)
						final_image.set_pixel(limit.x-1-x,limit.y-1-y,sample)
						final_image.set_pixel(y,limit.y-1-x,sample)
				mapping["symmetry"] = "four rotations of top-left quadrant; source retained"
		else:
			final_image = fit_image(cropped,limit)
		var final_path := "prepared/"+code+"_v01.png"
		assert(final_image.save_png(package_root.path_join(final_path)) == OK)
		var hotspot: Array = []
		if job.kind == "cursor":
			if code == "C03":
				hotspot = [20,20]
			else:
				var found := false
				for y in range(final_image.get_height()):
					for x in range(final_image.get_width()):
						if final_image.get_pixel(x,y).a > .5:
							hotspot = [x,y]
							found = true
							break
					if found:
						break
		results.append({"code":code,"revision":"v01","kind":job.kind,"source":job.source,"source_size":[source.get_width(),source.get_height()],"bbox":[bbox.position.x,bbox.position.y,bbox.end.x,bbox.end.y],"key_pixels_removed":key_count,"eroded_native_pixels":eroded_count,"native":native_path,"final":final_path,"final_size":[final_image.get_width(),final_image.get_height()],"method":method,"mapping":mapping,"hotspot":hotspot,"content_state":"DRAFT","runtime_admission":false})
	var out := FileAccess.open(package_root.path_join("normalization.json"),FileAccess.WRITE)
	out.store_string(JSON.stringify({"records":results},"\t"))
	out.close()
	print(JSON.stringify({"normalized":results.size(),"runtime_admission":false}))
	quit()

func fit_image(source: Image,limit: Vector2i) -> Image:
	var factor := minf(1.0,minf(float(limit.x)/source.get_width(),float(limit.y)/source.get_height()))
	var output: Image = source.duplicate()
	output.resize(maxi(1,floori(source.get_width()*factor)),maxi(1,floori(source.get_height()*factor)),Image.INTERPOLATE_NEAREST)
	return output

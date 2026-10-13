extends SceneTree

var package: String
var config: Array = [
	{"name":"back", "rect":[94,17,107,41], "shift":true, "phase":0.0},
	{"name":"right", "rect":[128,34,139,54], "shift":true, "phase":1.4},
	{"name":"left", "rect":[64,58,72,68], "shift":false, "phase":2.8},
	{"name":"front", "rect":[121,73,129,82], "shift":false, "phase":4.2},
	{"name":"embers", "rect":[86,70,107,77], "shift":false, "phase":0.9}
]

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	package = args[0].replace("\\", "/")
	var base := Image.new()
	assert(base.load(package.path_join("base.png")) == OK)
	base.convert(Image.FORMAT_RGBA8)
	for folder in ["masks", "frames", "normalized"]:
		DirAccess.make_dir_recursive_absolute(package.path_join(folder))
	if args[1] == "masks":
		make_masks(base)
	else:
		make_frames(base)
	quit()

func make_masks(base: Image) -> void:
	var allowed := Image.create(192,192,false,Image.FORMAT_L8)
	allowed.fill(Color.BLACK)
	var fire := Image.create(192,192,false,Image.FORMAT_L8)
	fire.fill(Color.BLACK)
	for item in config:
		var mask := Image.create(192,192,false,Image.FORMAT_L8)
		mask.fill(Color.BLACK)
		var r: Array = item.rect
		var count: int = 0
		for y in range(r[1],r[3]):
			for x in range(r[0],r[2]):
				var p: Color = base.get_pixel(x,y)
				# Manual regions identify effects; bright/warm pixels refine them.
				if p.a > 0.99 and p.r > 0.55 and p.r >= p.b * 0.85 and p.g > 0.03:
					mask.set_pixel(x,y,Color.WHITE)
					fire.set_pixel(x,y,Color.WHITE)
					count += 1
		# Moving flame envelopes must contain no non-fire object pixels.
		if item.shift:
			for y in range(r[1],r[3]):
				for x in range(r[0]-1,r[2]+1):
					if base.get_pixel(x,y).a > 0.0 and mask.get_pixel(x,y).r < 0.5:
						item.shift = false
						break
		for y in 192:
			for x in 192:
				if mask.get_pixel(x,y).r > 0.5:
					allowed.set_pixel(x,y,Color.WHITE)
					if item.shift:
						allowed.set_pixel(x-1,y,Color.WHITE)
						allowed.set_pixel(x+1,y,Color.WHITE)
		item["pixels"] = count
		assert(mask.save_png(package.path_join("masks/"+item.name+".png")) == OK)
	var body := Image.create(192,192,false,Image.FORMAT_L8)
	body.fill(Color.BLACK)
	var preview: Image = base.duplicate()
	for y in 192:
		for x in 192:
			if base.get_pixel(x,y).a > 0.0 and fire.get_pixel(x,y).r < 0.5:
				body.set_pixel(x,y,Color.WHITE)
			if fire.get_pixel(x,y).r > 0.5:
				preview.set_pixel(x,y,Color(0.2,1.0,0.3,1))
			elif allowed.get_pixel(x,y).r > 0.5:
				preview.set_pixel(x,y,Color(0.15,0.7,1,1))
	assert(body.save_png(package.path_join("masks/body.png")) == OK)
	assert(fire.save_png(package.path_join("masks/fire.png")) == OK)
	assert(allowed.save_png(package.path_join("masks/allowed-effects.png")) == OK)
	preview.resize(768,768,Image.INTERPOLATE_NEAREST)
	var canvas := Image.create(768,768,false,Image.FORMAT_RGBA8)
	canvas.fill(Color(0.18,0.18,0.21,1))
	canvas.blend_rect(preview,Rect2i(0,0,768,768),Vector2i.ZERO)
	assert(canvas.save_png(package.path_join("masks-preview.png")) == OK)
	var file := FileAccess.open(package.path_join("parameters.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"revision":"AL01-CORR/v01", "tool":"Godot 4.7.2 Image", "phases":6, "preview_ms":900, "effects":config, "body":"all native opaque pixels outside fire masks", "motion_fallback":"brightness only when envelope intersects non-fire object", "max_shift_px":1},"  "))
	print("masks saved ",JSON.stringify(config))

func make_frames(base: Image) -> void:
	var params: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package.path_join("parameters.json")))
	var effects: Array = params.effects
	var strip := Image.create(1152,192,false,Image.FORMAT_RGBA8)
	strip.fill(Color.TRANSPARENT)
	var timeline: Array = []
	for i in 6:
		var frame: Image = base.duplicate()
		var steps: Array = []
		for item in effects:
			var mask := Image.new()
			assert(mask.load(package.path_join("masks/"+item.name+".png")) == OK)
			var phase: float = TAU * i / 6.0 + float(item.phase)
			var shift: int = roundi(sin(phase)) if item.shift else 0
			var gain: float = 0.98 + (0.12 if item.name=="embers" else 0.075) * sin(phase)
			if item.shift:
				for y in 192:
					for x in 192:
						if mask.get_pixel(x,y).r > 0.5:
							frame.set_pixel(x,y,Color.TRANSPARENT)
			for y in 192:
				for x in 192:
					if mask.get_pixel(x,y).r > 0.5:
						var p: Color = base.get_pixel(x,y)
						frame.set_pixel(x+shift,y,Color(minf(p.r*gain,1),minf(p.g*gain,1),minf(p.b*gain,1),p.a))
			steps.append({"name":item.name,"shift":shift,"gain":gain})
		assert(frame.save_png(package.path_join("frames/AL01_loop_v03_f%d.png"%i)) == OK)
		strip.blit_rect(frame,Rect2i(0,0,192,192),Vector2i(i*192,0))
		timeline.append({"frame":i,"effects":steps})
	assert(strip.save_png(package.path_join("normalized/AL01_loop_v03.png")) == OK)
	params["timeline"] = timeline
	var file := FileAccess.open(package.path_join("parameters.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(params,"  "))
	var contact := Image.create(1152,192,false,Image.FORMAT_RGBA8)
	contact.fill(Color(0.18,0.18,0.21,1))
	contact.blend_rect(strip,Rect2i(0,0,1152,192),Vector2i.ZERO)
	assert(contact.save_png(package.path_join("frames-preview.png")) == OK)
	print("six corrected frames packed")

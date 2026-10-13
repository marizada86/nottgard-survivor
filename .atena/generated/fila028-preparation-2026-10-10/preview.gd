extends SceneTree
func _init() -> void:
	var package: String = OS.get_cmdline_user_args()[0].replace("\\", "/")
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package.path_join("manifest.json")))
	var atlas := Image.create(1280, 1792, false, Image.FORMAT_RGBA8)
	atlas.fill(Color(0.19, 0.19, 0.23, 1))
	var i: int = 0
	for entry in manifest.entries:
		if entry.code == "AL01": continue
		var im := Image.new()
		assert(im.load(package.path_join("normalized/" + entry.code + "_" + entry.version + ".png")) == OK)
		var origin := Vector2i((i % 5) * 256 + (256 - im.get_width()) / 2, (i / 5) * 256 + (256 - im.get_height()) / 2)
		atlas.blend_rect(im, Rect2i(0, 0, im.get_width(), im.get_height()), origin)
		i += 1
	assert(atlas.save_png(package.path_join("contact.png")) == OK)
	var pair := Image.create(512, 256, false, Image.FORMAT_RGBA8)
	pair.fill(Color(0.19, 0.19, 0.23, 1))
	for n in 2:
		var chamber := Image.new()
		var filename: String = "SE02_v03.png" if n == 0 else "SE03_v02.png"
		assert(chamber.load(package.path_join("normalized/" + filename)) == OK)
		pair.blend_rect(chamber, Rect2i(0, 0, 256, 256), Vector2i(n * 256, 0))
	assert(pair.save_png(package.path_join("chambers-preview.png")) == OK)
	quit()

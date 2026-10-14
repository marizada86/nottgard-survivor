extends SceneTree
func _init() -> void:
	var out := "res://.atena/generated/assets-l001-admission-2026-10-13/"
	var receipt: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(out+"authorization.json"))
	for family in receipt.families:
		var source := Image.load_from_file(out+String(family.name)+".png")
		var preview := Image.create(1536,256,false,Image.FORMAT_RGB8)
		for y in 256:
			for x in 1536:
				var a := source.get_pixel(x,y).a
				preview.set_pixel(x,y,Color(a,a,a))
		assert(preview.save_png(out+String(family.name)+"-black-preview.png")==OK)
	quit()

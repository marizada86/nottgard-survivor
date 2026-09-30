extends SceneTree
## Converte fundos quase magenta/ciano dos brutos do Lote 2 em alfa, sem tocar nas fontes.

const SOURCE_ROOT := "res://.atena/generated/art-candidates/scenery"
const OUTPUT_ROOT := "res://.atena/generated/art-candidates/scenery-normalized"

func _init() -> void:
	var sources: Array[String] = []
	_collect(SOURCE_ROOT, sources)
	for source_path in sources:
		var image := Image.new()
		if image.load(source_path) != OK:
			printerr("failed to load: %s" % source_path)
			quit(1)
			return
		image.convert(Image.FORMAT_RGBA8)
		_remove_edge_connected_chroma_background(image)
		var relative := source_path.trim_prefix(SOURCE_ROOT + "/")
		var output_path := OUTPUT_ROOT.path_join(relative)
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output_path.get_base_dir()))
		if image.save_png(output_path) != OK:
			printerr("failed to save: %s" % output_path)
			quit(1)
			return
	quit()

func _collect(path: String, out: Array[String]) -> void:
	var dir := DirAccess.open(path)
	for file_name in dir.get_files():
		if file_name.ends_with("_v01.png"):
			out.append(path.path_join(file_name))
	for directory in dir.get_directories():
		_collect(path.path_join(directory), out)

## A média dos cantos não cobre o gradiente/ruído dos fundos gerados. Em vez
## de apagar qualquer roxo da arte, removemos apenas o magenta/ciano que está
## conectado à borda do PNG.
func _remove_edge_connected_chroma_background(image: Image) -> void:
	var width := image.get_width()
	var height := image.get_height()
	var mask := PackedByteArray()
	mask.resize(width * height)
	for y in height:
		for x in width:
			var index := y * width + x
			if _is_chroma_background(image.get_pixel(x, y)):
				mask[index] = 1
	var queue := PackedInt32Array()
	for x in width:
		_enqueue_edge(mask, queue, x, width)
		_enqueue_edge(mask, queue, (height - 1) * width + x, width)
	for y in height:
		_enqueue_edge(mask, queue, y * width, width)
		_enqueue_edge(mask, queue, y * width + width - 1, width)
	var cursor := 0
	while cursor < queue.size():
		var index := queue[cursor]
		cursor += 1
		var x := index % width
		var y := index / width
		if x > 0:
			_enqueue_edge(mask, queue, index - 1, width)
		if x < width - 1:
			_enqueue_edge(mask, queue, index + 1, width)
		if y > 0:
			_enqueue_edge(mask, queue, index - width, width)
		if y < height - 1:
			_enqueue_edge(mask, queue, index + width, width)
	for index in queue:
		var pixel := image.get_pixel(index % width, index / width)
		image.set_pixel(index % width, index / width, Color(pixel.r, pixel.g, pixel.b, 0.0))

func _enqueue_edge(mask: PackedByteArray, queue: PackedInt32Array, index: int, _width: int) -> void:
	if mask[index] != 1:
		return
	mask[index] = 2
	queue.append(index)

func _is_chroma_background(pixel: Color) -> bool:
	var magenta := minf(pixel.r, pixel.b) >= 0.45 and pixel.g <= minf(pixel.r, pixel.b) * 0.55
	var cyan := minf(pixel.g, pixel.b) >= 0.45 and pixel.r <= minf(pixel.g, pixel.b) * 0.55
	return magenta or cyan

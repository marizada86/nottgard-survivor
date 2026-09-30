extends SceneTree
## Promotes already-normalized Lot 2 candidates without changing their sources.

const SOURCE_ROOT := "res://.atena/generated/art-candidates/scenery-normalized"
const STRUCTURE_STAGES := ["dagruve", "docas", "shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis", "pilares"]

func _init() -> void:
	var failures: Array[String] = []
	for stage_id in STRUCTURE_STAGES:
		var prefix := SOURCE_ROOT.path_join(stage_id).path_join(stage_id)
		_fail_or_copy(prefix + "_estrutura_01_v01.png", "res://assets/props/%s_estrutura_01.png" % stage_id, 256, 256, failures)
		if stage_id == "docas":
			_fail_or_copy(prefix + "_remendo_01_v01.png", "res://assets/decals/docas_remendo_01.png", 256, 128, failures)
			_fail_or_copy(prefix + "_trilha_01_v01.png", "res://assets/decals/docas_trilha_01.png", 256, 128, failures)
	if not failures.is_empty():
		for failure in failures:
			printerr(failure)
		quit(1)
		return
	quit()

func _fail_or_copy(source: String, destination: String, width: int, height: int, failures: Array[String]) -> void:
	if FileAccess.file_exists(destination):
		failures.append("Refusing to overwrite: %s" % destination)
		return
	var image := Image.new()
	if image.load(ProjectSettings.globalize_path(source)) != OK or image.is_empty():
		failures.append("Could not load normalized candidate: %s" % source)
		return
	if image.get_format() != Image.FORMAT_RGBA8:
		image.convert(Image.FORMAT_RGBA8)
	if image.get_pixel(0, 0).a > 0.03 or image.get_pixel(image.get_width() - 1, image.get_height() - 1).a > 0.03:
		failures.append("Candidate corners are not transparent: %s" % source)
		return
	image.resize(width, height, Image.INTERPOLATE_NEAREST)
	var destination_path := ProjectSettings.globalize_path(destination)
	DirAccess.make_dir_recursive_absolute(destination_path.get_base_dir())
	if image.save_png(destination) != OK:
		failures.append("Could not save official asset: %s" % destination)

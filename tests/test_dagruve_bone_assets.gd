extends RefCounted

const ASSETS := [
	"res://assets/props/ossos_01.png",
	"res://assets/props/ossos_02.png",
	"res://assets/props/ossos_03.png",
]

func run() -> Array[String]:
	var failures: Array[String] = []
	for path in ASSETS:
		if not FileAccess.file_exists(path):
			failures.append("asset ausente: %s" % path)
			continue
		var image := Image.new()
		if image.load(ProjectSettings.globalize_path(path)) != OK:
			failures.append("PNG inválido: %s" % path)
		elif image.get_size() != Vector2i(256, 256):
			failures.append("dimensão inválida em %s: %s" % [path, image.get_size()])
		elif image.detect_alpha() == Image.ALPHA_NONE:
			failures.append("sem canal alfa: %s" % path)
	var prop_script: Script = load("res://ui/prop.gd")
	var has_bones := false
	for property in prop_script.get_script_property_list():
		if property.name == "kind" and "ossos" in property.hint_string:
			has_bones = true
	if not has_bones:
		failures.append("kind ossos não está exposto em ui/prop.gd")
	return failures

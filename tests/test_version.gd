extends RefCounted

func run() -> Array:
	var out: Array = []
	if Version.VERSION == "":
		out.append("VERSION vazio")
	return out

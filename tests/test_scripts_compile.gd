extends RefCounted
## Regressão: um erro de parse em ui/ ou core/ só aparecia ao jogar (tela preta ao iniciar a run).

const DIRS := ["res://core", "res://ui"]

func run() -> Array:
	var out: Array = []
	for d in DIRS:
		for f in DirAccess.get_files_at(d):
			if not f.ends_with(".gd"):
				continue
			var path := "%s/%s" % [d, f]
			var scr = load(path)
			if scr == null or not scr.can_instantiate():
				out.append("%s não compila" % path)
	return out

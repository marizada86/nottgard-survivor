extends RefCounted
## SPEC-154 (BUG-029): tiras de herói pré-reduzidas (HERO_STRIP_SET). Cada herói reduzido mantém a altura em tela, os pés na
## mesma linha, os mesmos quadros por tira e nada cortado na borda; os originais continuam intactos.

const HeroViewScript := preload("res://ui/hero_view.gd")
const CELL := Vector2i(256, 384)
const USED := ["idle", "move_e", "move_se", "move_s", "move_n", "move_ne", "attack", "active", "death"]
const ALPHA_VISIBLE := 8

func run() -> Array:
	var out: Array = []
	var set: Dictionary = HeroViewScript.HERO_STRIP_SET
	# Vazio por decisão do dono (2026-10-09): o piloto do Kayron não foi adotado. Qualquer entrada futura é validada abaixo.
	for key in set:
		_hero(out, String(key))
	_helpers(out)
	if set.is_empty():
		_pilot_files(out)
	return out

func _stats(frame: Image) -> Dictionary:
	var w := frame.get_width()
	var h := frame.get_height()
	var top := h
	var bottom := -1
	var min_d := 9999
	var core := 0
	var solid := 0.0
	for y in h:
		for x in w:
			var a := int(round(frame.get_pixel(x, y).a * 255.0))
			if a <= ALPHA_VISIBLE:
				continue
			top = mini(top, y)
			bottom = maxi(bottom, y)
			min_d = mini(min_d, mini(mini(x, y), mini(w - 1 - x, h - 1 - y)))
			if a > 128:
				core += 1
				solid += float(a) / 255.0
	return {"height": bottom - top + 1, "feet": bottom + 1, "min_d": min_d, "solidity": solid / float(maxi(core, 1))}

func _hero(out: Array, hero: String) -> void:
	var key := StringName(hero)
	var entry: Dictionary = HeroViewScript.HERO_STRIP_SET[key]
	var factor := float(entry.factor)
	var pad := int(entry.get("pad", 0))
	var display := float(HeroViewScript.HERO_DISPLAY_HEIGHT[key])
	var art := float(HeroViewScript.HERO_IDLE_ART_HEIGHT[key])
	# o fator é o dobro (ou o mesmo) da altura em tela sobre a altura da arte, para a escala em tela ser 0,5 (ou 1,0)
	var ratio := factor / (display / art)
	if absf(ratio - 2.0) > 0.001 and absf(ratio - 1.0) > 0.001:
		out.append("%s: o fator %.5f deveria ser 1x ou 2x altura em tela / altura da arte (%.5f)" % [hero, factor, display / art])
	if pad < 2:
		out.append("%s: a margem deveria ser de pelo menos 2 px (é %d)" % [hero, pad])
	var cell: Vector2i = HeroViewScript.cell_of(hero)
	if cell != Vector2i(ceili(CELL.x * factor) + 2 * pad, ceili(CELL.y * factor) + 2 * pad):
		out.append("%s: célula inesperada %s" % [hero, str(cell)])
	# altura em tela: a escala do sprite vezes a altura da arte reduzida dá a altura de hoje
	var on_screen := HeroViewScript.display_scale(hero) * art * factor
	if absf(on_screen - display) > 0.01:
		out.append("%s: altura em tela mudaria (%.2f, era %.2f)" % [hero, on_screen, display])
	var src_dir := "res://assets/animations/heroes/%s" % hero
	var dir := String(entry.dir)
	for name_ in USED:
		var original_path := "%s/%s.png" % [src_dir, name_]
		var reduced_path := "%s/%s.png" % [dir, name_]
		if not FileAccess.file_exists(original_path):
			out.append("%s: o original %s foi perdido" % [hero, original_path])
			continue
		if not FileAccess.file_exists(reduced_path):
			out.append("%s: falta a tira reduzida %s" % [hero, name_])
			continue
		var original := Image.load_from_file(ProjectSettings.globalize_path(original_path))
		var reduced := Image.load_from_file(ProjectSettings.globalize_path(reduced_path))
		var frames := original.get_width() / CELL.x
		if reduced.get_width() != frames * cell.x or reduced.get_height() != cell.y:
			out.append("%s/%s: tamanho %dx%d, esperado %dx%d (%d quadros)" % [hero, name_, reduced.get_width(), reduced.get_height(), frames * cell.x, cell.y, frames])
			continue
		for k in frames:
			var o := _stats(original.get_region(Rect2i(k * CELL.x, 0, CELL.x, CELL.y)))
			var r := _stats(reduced.get_region(Rect2i(k * cell.x, 0, cell.x, cell.y)))
			if int(r.min_d) < 2:
				out.append("%s/%s quadro %d: pixel visível a %d px da borda (nada pode ser cortado)" % [hero, name_, k, r.min_d])
			if int(o.height) > 0:
				var want := float(o.height) * factor
				if absf(float(r.height) - want) > 2.5:
					out.append("%s/%s quadro %d: altura %d, esperada %.1f" % [hero, name_, k, r.height, want])
				var want_feet := float(o.feet) * factor + float(pad)
				if absf(float(r.feet) - want_feet) > 2.0:
					out.append("%s/%s quadro %d: pés em %d, esperado %.1f" % [hero, name_, k, r.feet, want_feet])
				if absf(float(r.solidity) - float(o.solidity)) > 0.03:
					out.append("%s/%s quadro %d: solidez do miolo %.3f contra %.3f" % [hero, name_, k, r.solidity, o.solidity])
	# a linha dos pés do idle (quadro 0) acompanha a tabela HERO_FEET_Y
	var idle := Image.load_from_file(ProjectSettings.globalize_path("%s/idle.png" % dir))
	var idle_stats := _stats(idle.get_region(Rect2i(0, 0, cell.x, cell.y)))
	var table_feet := float(HeroViewScript.HERO_FEET_Y[key]) * factor + float(pad)
	if absf(float(idle_stats.feet) - table_feet) > 2.0:
		out.append("%s: pés do idle em %d, HERO_FEET_Y reduzido dá %.1f" % [hero, idle_stats.feet, table_feet])

func _helpers(out: Array) -> void:
	# sem entrada na tabela, o herói segue com a célula e a escala originais
	if HeroViewScript.cell_of("durvall") != CELL or HeroViewScript.strip_factor("durvall") != 1.0 or HeroViewScript.strip_pad("durvall") != 0:
		out.append("herói fora da tabela deveria manter célula 256x384, fator 1 e margem 0")
	var saved: Dictionary = HeroViewScript.strip_override
	HeroViewScript.strip_override = {&"kayron": {}}
	if HeroViewScript.cell_of("kayron") != CELL:
		out.append("strip_override vazio deveria devolver o conjunto original")
	HeroViewScript.strip_override = saved

## Com a tabela vazia, o jogo usa só os originais; as tiras do piloto (se ainda existirem) não podem alterar a célula nem a escala.
func _pilot_files(out: Array) -> void:
	for hero in ["kayron", "durvall", "korrak"]:
		if HeroViewScript.cell_of(hero) != CELL or HeroViewScript.strip_factor(hero) != 1.0:
			out.append("%s: sem entrada na tabela deveria usar a célula e o fator originais" % hero)
		if not FileAccess.file_exists("res://assets/animations/heroes/%s/idle.png" % hero):
			out.append("%s: o original idle.png foi perdido" % hero)

extends SceneTree
## Auditoria de integridade do projeto (varredura 0.2.0 -> atual). Somente leitura.
##   godot --headless --path . -s tools/audit_projeto.gd
## Saída: linhas "ERRO;area;detalhe", "AVISO;area;detalhe", "INFO;..." e um resumo.

var _erros := 0
var _avisos := 0

func _e(area: String, d: String) -> void:
	_erros += 1
	print("ERRO;%s;%s" % [area, d])

func _w(area: String, d: String) -> void:
	_avisos += 1
	print("AVISO;%s;%s" % [area, d])

func _t(n: String) -> Dictionary:
	return Data.table(n)

func _scan_res(area: String, v: Variant, path: String) -> void:
	if v is String:
		var s := String(v)
		if s.begins_with("res://") and not FileAccess.file_exists(s) and not ResourceLoader.exists(s):
			_e(area, "arquivo ausente %s (em %s)" % [s, path])
	elif v is Dictionary:
		for k in v:
			_scan_res(area, v[k], "%s/%s" % [path, k])
	elif v is Array:
		for i in v.size():
			_scan_res(area, v[i], "%s[%d]" % [path, i])

func _init() -> void:
	var names := ["abilities", "achievements", "audio_manifest", "barks", "boon_effects", "boons", "boss_phases", "boss_presentations", "chronicles", "difficulty",
		"enemies", "ground_decals", "hero_bios", "heroes", "hqs", "item_effects", "items", "level_design", "passives", "prop_visuals", "scenery", "stage_events",
		"stage_rules", "stage_story", "stage_structures", "stages", "upgrades", "weapons"]
	for n in names:
		_scan_res("res-" + n, _t(n), n)
	var enemies := _t("enemies")
	var weapons := _t("weapons")
	var stages := _t("stages")
	var items := _t("items")
	var passives := _t("passives")
	var heroes := _t("heroes")
	# heróis
	for h in heroes:
		var w := String(heroes[h].get("weapon", ""))
		if not weapons.has(w):
			_e("heroes", "%s: arma inicial inexistente %s" % [h, w])
		if not FileAccess.file_exists("res://assets/heroes/%s.png" % h):
			_w("heroes", "%s: sem assets/heroes/%s.png" % [h, h])
		if not _t("hero_bios").has(h):
			_w("hero_bios", "%s sem bio" % h)
		if not _t("barks").has(h):
			_w("barks", "%s sem barks" % h)
	# armas
	var base_ids: Array = []
	for slot in items.bases:
		for b in items.bases[slot]:
			base_ids.append(String(b.id))
	for id in weapons:
		var d: Dictionary = weapons[id]
		if d.has("evolve"):
			var into := String(d.evolve.get("into", ""))
			if not weapons.has(into):
				_e("weapons", "%s evolui para inexistente %s" % [id, into])
			var ps := String(d.evolve.get("passive", ""))
			if not passives.has(ps) and not weapons.has(ps) and not _t("upgrades").has(ps):
				_w("weapons", "%s: passiva de evolução %s não está em passives/upgrades" % [id, ps])
		if d.has("synergy") and not (String(d.synergy.get("item_base", "")) in base_ids):
			_e("weapons", "%s: synergy.item_base %s não é base de item" % [id, d.synergy.get("item_base", "")])
		for k in ["kind", "dice", "cd"]:
			if not d.has(k) and not (id.begins_with("_")):
				_w("weapons", "%s sem campo %s" % [id, k])
		var lv: Array = d.get("levels", [])
		if not lv.is_empty() and lv.size() != 4:
			_w("weapons", "%s tem %d níveis de upgrade (esperado 4)" % [id, lv.size()])
	# itens
	var slots := ["arma", "armadura", "amuleto", "anel"]
	for u in items.uniques:
		if not (String(u.slot) in slots):
			_e("items", "único %s com slot inválido %s" % [u.id, u.slot])
		var uw := String(u.get("weapon", ""))
		if uw != "" and not weapons.has(uw):
			_e("items", "único %s aponta arma inexistente %s" % [u.id, uw])
		if (u.mods as Dictionary).is_empty():
			_e("items", "único %s sem mods" % u.id)
	var seen := {}
	for u in items.uniques:
		if seen.has(u.id):
			_e("items", "único duplicado %s" % u.id)
		seen[u.id] = true
	# fases
	var order_seen := {}
	var prev: Dictionary = {}
	var ordered: Array = stages.keys()
	ordered.sort_custom(func(a, b): return int(stages[a].order) < int(stages[b].order))
	for k in ordered:
		var s: Dictionary = stages[k]
		if order_seen.has(int(s.order)):
			_e("stages", "order repetido %d (%s)" % [s.order, k])
		order_seen[int(s.order)] = true
		if s.has("next") and String(s.next) != "" and not stages.has(String(s.next)):
			_e("stages", "%s: next inexistente %s" % [k, s.next])
		if not enemies.has(String(s.get("boss", "x"))) and not s.get("endless", false):
			_e("stages", "%s: chefe inexistente %s" % [k, s.get("boss", "")])
		for w in s.get("waves", []):
			if not enemies.has(String(w.id)):
				_e("stages", "%s: onda com inimigo inexistente %s" % [k, w.id])
		for el in s.get("elites", []):
			if not enemies.has(String(el.id)):
				_e("stages", "%s: elite inexistente %s" % [k, el.id])
		for ik in s.get("interactions", {}):
			if not (String(ik) in ["chest", "fountain", "altar", "ritual", "loja", "ferreiro", "curandeiro", "ampulheta", "doacao", "aposta"]):
				_w("stages", "%s: interação desconhecida %s" % [k, ik])
		for t in ["boss_phases", "boss_presentations"]:
			if enemies.has(String(s.get("boss", ""))) and not _t(t).has(String(s.boss)):
				_w(t, "%s: chefe %s sem entrada" % [k, s.boss])
		for t in ["stage_story", "chronicles", "stage_rules", "stage_events"]:
			if not _t(t).has(k):
				_w(t, "fase %s sem entrada" % k)
		if not prev.is_empty():
			for f in ["hp_mult", "dmg_mult", "coin_mult", "tier"]:
				if float(s.get(f, 0)) < float(prev.get(f, 0)):
					_w("curva", "%s.%s=%s menor que a fase anterior (%s)" % [k, f, s.get(f), prev.get(f)])
		prev = s
	# eventos de fase
	for k in _t("stage_events"):
		if String(k).begins_with("_") or not (_t("stage_events")[k] is Array):
			continue
		for ev in _t("stage_events")[k]:
			for f in ["enemy_id"]:
				if ev.has(f) and not enemies.has(String(ev[f])):
					_e("stage_events", "%s/%s: inimigo inexistente %s" % [k, ev.id, ev[f]])
			var fail: Dictionary = ev.get("fail", {})
			if fail.has("elite") and not enemies.has(String(fail.elite)):
				_e("stage_events", "%s/%s: elite de falha inexistente" % [k, ev.id])
	# inimigos
	for id in enemies:
		var e: Dictionary = enemies[id]
		if float(e.get("hp", 0)) <= 0.0:
			_e("enemies", "%s sem hp" % id)
		if not e.has("xp"):
			_w("enemies", "%s sem xp" % id)
		for sp in ["speed", "radius"]:
			if not e.has(sp):
				_w("enemies", "%s sem %s" % [id, sp])
	# áudio: eventos citados no código existem no manifesto
	var ev_audio: Dictionary = _t("audio_manifest").get("events", {})
	var f := DirAccess.get_files_at("res://core")
	for fn in f:
		if not fn.ends_with(".gd"):
			continue
		var txt := FileAccess.get_file_as_string("res://core/" + fn)
		var rx := RegEx.new()
		rx.compile("Sfx[.]play[(]\"([a-z0-9_.]+)\"")
		for m in rx.search_all(txt):
			if not ev_audio.has(m.get_string(1)):
				_w("audio", "core/%s usa Sfx.play(%s) sem entrada no manifesto" % [fn, m.get_string(1)])
	# XP por HP dos inimigos comuns
	var ratios: Array = []
	for id in enemies:
		var e: Dictionary = enemies[id]
		if float(e.get("xp", 0)) > 0.0 and float(e.hp) > 0.0:
			ratios.append(float(e.xp) / float(e.hp))
	ratios.sort()
	print("INFO;xp/hp;mediana=%.2f min=%.2f max=%.2f (n=%d)" % [ratios[ratios.size() / 2], ratios[0], ratios[-1], ratios.size()])
	print("RESUMO;erros=%d;avisos=%d" % [_erros, _avisos])
	quit()

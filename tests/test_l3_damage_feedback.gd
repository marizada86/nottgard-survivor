extends RefCounted
## L3 do relato do T05 (EVID-250/EVID-252): faixas de número de dano, volume e tom do acerto e pausa de acerto.

func run() -> Array:
	var out: Array = []
	# faixas: comum só sobe com crítico; elite e chefe sobem pela fração do PV
	if DamageFeedback.band(1.0, "", false) != 0:
		out.append("um comum que morre num golpe não é um golpe 'enorme': faixa 0")
	if DamageFeedback.band(0.5, "", true) != 2:
		out.append("crítico em comum deveria ir à faixa 2")
	var expected := [[0.01, 0], [0.03, 1], [0.079, 1], [0.08, 2], [0.15, 3], [0.9, 3]]
	for pair in expected:
		if DamageFeedback.band(float(pair[0]), "elite", false) != int(pair[1]):
			out.append("elite com %.3f do PV deveria ser faixa %d (deu %d)" % [pair[0], pair[1], DamageFeedback.band(float(pair[0]), "elite", false)])
	if DamageFeedback.band(0.01, "boss", true) != 2 or DamageFeedback.band(0.2, "boss", true) != 3:
		out.append("crítico em chefe: faixa 2 no mínimo e 3 no golpe grande")
	# número: cresce com a faixa, crítico soma 2 px
	var last := 0
	for b in 4:
		var size := DamageFeedback.number_size(b, false)
		if size <= last:
			out.append("o tamanho do número deveria crescer com a faixa (faixa %d: %d)" % [b, size])
		last = size
	if DamageFeedback.number_size(0, false) != 16:
		out.append("o número comum fica em 16 px (M2 R5, opção B)")
	if DamageFeedback.number_size(2, true) != DamageFeedback.number_size(2, false) + 2:
		out.append("crítico deveria somar 2 px ao tamanho da faixa")
	if DamageFeedback.number_size(3, true) < 30:
		out.append("golpe enorme crítico deveria ter ao menos 30 px")
	# som: o comum fica onde estava; o forte sobe; há teto
	if DamageFeedback.sound_db(0, false, "") != -14.0:
		out.append("o acerto comum deveria seguir em -14 dB")
	var db_last := -99.0
	for b in 4:
		var db := DamageFeedback.sound_db(b, false, "")
		if db <= db_last:
			out.append("o volume deveria subir com a faixa")
		db_last = db
	if DamageFeedback.sound_db(3, true, "boss") > -7.0:
		out.append("o volume do acerto tem teto de -7 dB")
	if DamageFeedback.sound_db(2, true, "") <= DamageFeedback.sound_db(2, false, ""):
		out.append("crítico deveria soar mais alto que o golpe da mesma faixa")
	var pitch_last := 2.0
	for b in 4:
		var p := DamageFeedback.sound_pitch(b)
		if p >= pitch_last:
			out.append("o tom deveria ficar mais grave com a faixa")
		pitch_last = p
	if DamageFeedback.sound_pitch(0) != 1.0:
		out.append("o acerto comum fica no tom normal")
	# pausa de acerto
	if DamageFeedback.hit_stop(0, false, "") != 0.0 or DamageFeedback.hit_stop(2, true, "") != 0.04:
		out.append("comum: sem pausa, e 0,04 s no crítico como antes")
	if DamageFeedback.hit_stop(2, false, "elite") <= 0.0 or DamageFeedback.hit_stop(1, false, "elite") != 0.0:
		out.append("elite: pausa só a partir da faixa 2")
	if DamageFeedback.hit_stop(3, true, "boss") > 0.15:
		out.append("a pausa de acerto não pode passar do teto de 0,15 s")
	# o evento de acerto leva a faixa
	var b := Battle.new(3, "durvall", "dagruve")
	b.stage.waves = []
	b.stage.elites = []
	b.hero.weapons.clear()
	var zombie: Enemy = b.spawn_for_test("zumbi", b.hero.pos + Vector2(1.0, 0.0))
	b.events.clear()
	b._hero_hit(zombie, {"dice": "1d4", "attr": "forca", "kind": "melee", "dtype": "fisico", "id": "teste"}, false)
	var hit_events: Array = b.events.filter(func(e): return e.type == "hit")
	if hit_events.is_empty():
		out.append("o golpe de teste deveria gerar o evento hit")
	else:
		var hit: Dictionary = hit_events[0]
		if String(hit.get("tier", "x")) != "" or not hit.has("frac"):
			out.append("o evento hit deveria trazer tier e frac (comum = '')")
	return out

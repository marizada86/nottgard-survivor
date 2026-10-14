extends RefCounted

func run() -> Array[String]:
	var failures: Array[String] = []
	for weapon in RadiantOrbVfx.WEAPONS:
		var w := Weapon.make(weapon)
		var params := w.params()
		params["_audio_id"] = weapon
		var projectile := {"owner": "hero", "p": params, "pos": Vector2(20,20), "dir": Vector2.RIGHT}
		if not RadiantOrbVfx.supports_projectile(projectile) or RadiantOrbVfx.supports_projectile(projectile, true): failures.append("allowlist/reduzido incorretos: " + weapon)
		var before := projectile.duplicate(true)
		var battle := Battle.new(163, "maelor", "dagruve")
		battle.hero.pos = Vector2(20,20)
		battle.spawn_for_test("zumbi", Vector2(21,20))
		battle.events.clear()
		battle._hero_hit(battle.enemies[0], params, false)
		var hits := battle.events.filter(func(e: Dictionary) -> bool: return e.type == "hit")
		if hits.size() != 1 or not RadiantOrbVfx.supports_hit(hits[0]): failures.append("hit real não identifica a arma: " + weapon)
		if projectile != before: failures.append("helper altera projétil")
	var hit := {"type":"hit", "kind":"bolt", "dtype":"radiante", "weapon":"raio_de_luz", "pos":Vector2(12,9)}
	for field in ["type","kind","dtype","weapon"]:
		var other := hit.duplicate()
		other[field] = "unsupported"
		if RadiantOrbVfx.supports_hit(other): failures.append("impacto aceita " + field + " indevido")
	var secondary := hit.duplicate()
	secondary.erase("kind")
	secondary.erase("weapon")
	if RadiantOrbVfx.supports_hit(secondary) or RadiantOrbVfx.supports_hit(hit,true): failures.append("hit secundário/reduzido aceito")
	for owner in ["enemy", "pet"]:
		if RadiantOrbVfx.supports_projectile({"owner":owner,"p":{"kind":"bolt","dtype":"radiante","id":"raio_de_luz"}}): failures.append("owner indevido")
	for path in [RadiantOrbVfx.FLIGHT_PATH, RadiantOrbVfx.IMPACT_PATH]:
		var texture := RadiantOrbVfx.texture(path)
		if not RadiantOrbVfx.valid_texture(texture):
			failures.append("atlas inválido: " + path)
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		for frame in 4:
			for edge in 256:
				if image.get_pixel(frame*256+edge,0).a != 0 or image.get_pixel(frame*256+edge,255).a != 0 or image.get_pixel(frame*256,edge).a != 0 or image.get_pixel(frame*256+255,edge).a != 0: failures.append("borda não transparente")
	if RadiantOrbVfx.valid_texture(null) or RadiantOrbVfx.texture("res://assets/vfx/missing_orb.png") != null: failures.append("recurso ausente não faz fallback")
	var invalid := ImageTexture.create_from_image(Image.create(32,32,false,Image.FORMAT_RGBA8))
	if RadiantOrbVfx.valid_texture(invalid): failures.append("atlas malformado aceito")
	if RadiantOrbVfx.flight_frame(0.333334) != 0 or RadiantOrbVfx.flight_frame(0.26) != 3 or RadiantOrbVfx.impact_frame(0.239) != 3: failures.append("cadência/loop incorretos")
	if RadiantOrbVfx.screen_position(hit.pos) != Iso.to_screen(hit.pos)+Vector2(0,-16): failures.append("altura do projétil alterada")
	for i in 8:
		var dir := Vector2.from_angle(i*TAU/8)
		if not is_equal_approx(RadiantOrbVfx.flight_angle(dir),Iso.to_screen(dir).angle()): failures.append("direção projetada incorreta")
	var layer: Node = load("res://ui/radiant_orb_layer.gd").new()
	layer.battle = Battle.new(164,"maelor","dagruve")
	for i in RadiantOrbVfx.MAX_IMPACTS:
		if not layer.spawn_impact(hit): failures.append("impacto suportado recusado antes do teto")
	if layer.spawn_impact(hit) or layer.impacts.size() != RadiantOrbVfx.MAX_IMPACTS: failures.append("teto de impactos não respeitado")
	layer.free()
	return failures

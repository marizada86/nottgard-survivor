extends RefCounted

func run() -> Array[String]:
	var failures: Array[String] = []
	for weapon in ArcaneOrbVfx.WEAPONS:
		var params := Weapon.make(weapon).params()
		params["_audio_id"] = weapon
		var projectile := {"owner":"hero","p":params,"pos":Vector2(20,20),"dir":Vector2.RIGHT}
		if not ArcaneOrbVfx.supports_projectile(projectile) or ArcaneOrbVfx.supports_projectile(projectile,true) or RadiantOrbVfx.supports_projectile(projectile): failures.append("allowlist/reduzido/família incorretos: "+weapon)
		var b := Battle.new(163,"maelor","dagruve")
		b.hero.pos = Vector2(20,20)
		b.spawn_for_test("zumbi",Vector2(21,20))
		var enemy: Enemy = b.enemies[0]
		enemy.hp = 10000
		var ca := enemy.ca
		b.events.clear()
		b._hero_hit(enemy,params,false)
		var hits := b.events.filter(func(e: Dictionary) -> bool: return e.type=="hit")
		if hits.size()!=1 or not ArcaneOrbVfx.supports_hit(hits[0]): failures.append("evento real não identifica arma "+weapon)
		if weapon=="raio_enfraquecedor" and enemy.ca != ca-2: failures.append("enfraquecimento foi alterado")
		if weapon=="dominar_pessoa" and not is_equal_approx(enemy.stun_t,2.5): failures.append("atordoamento foi alterado")
	for weapon in ["memoria_alterada","dominio_da_vontade","lamina_trovejante","tempestade","raio_de_luz"]:
		var params := Weapon.make(weapon).params()
		params["_audio_id"] = weapon
		if ArcaneOrbVfx.supports_params(params): failures.append("arma fora do escopo aceita: "+weapon)
	var arc := {"type":"hit","kind":"bolt","dtype":"magico","weapon":"raio_enfraquecedor","pos":Vector2(20,20)}
	for field in ["type","kind","dtype","weapon"]:
		var bad := arc.duplicate()
		bad[field] = "unsupported"
		if ArcaneOrbVfx.supports_hit(bad): failures.append("impacto aceita "+field+" indevido")
	if ArcaneOrbVfx.supports_projectile({"owner":"enemy","p":{"kind":"bolt","dtype":"magico","id":"raio_enfraquecedor"}}): failures.append("projétil inimigo aceito")
	for path in [ArcaneOrbVfx.FLIGHT_PATH,ArcaneOrbVfx.IMPACT_PATH]:
		var texture := RadiantOrbVfx.texture(path)
		if not RadiantOrbVfx.valid_texture(texture):
			failures.append("atlas inválido: "+path)
			continue
		var image := texture.get_image()
		if image.is_compressed(): image.decompress()
		for frame in 4:
			for edge in 256:
				if image.get_pixel(frame*256+edge,0).a!=0 or image.get_pixel(frame*256+edge,255).a!=0 or image.get_pixel(frame*256,edge).a!=0 or image.get_pixel(frame*256+255,edge).a!=0: failures.append("borda não transparente")
	var layer: Node = load("res://ui/radiant_orb_layer.gd").new()
	layer.battle = Battle.new(164,"maelor","dagruve")
	var radiant := arc.duplicate()
	radiant.dtype = "radiante"
	radiant.weapon = "raio_de_luz"
	for i in RadiantOrbVfx.MAX_IMPACTS:
		var event: Dictionary = arc if i%2==0 else radiant
		if not layer.spawn_impact(event): failures.append("família mista recusada antes do teto")
		elif layer.impacts[-1].family != (ArcaneOrbVfx if i%2==0 else RadiantOrbVfx): failures.append("família/tinta cruzada no impacto")
	if layer.spawn_impact(arc) or layer.impacts.size()!=32: failures.append("orçamento combinado ultrapassado")
	var arc_pr := {"owner":"hero","p":{"kind":"bolt","dtype":"magico","id":"raio_enfraquecedor"}}
	var rad_pr := {"owner":"hero","p":{"kind":"bolt","dtype":"radiante","id":"raio_de_luz"}}
	var texture: Texture2D = RadiantOrbVfx.texture(ArcaneOrbVfx.FLIGHT_PATH)
	RadiantOrbVfx._textures[ArcaneOrbVfx.FLIGHT_PATH] = null
	if layer.can_draw_projectile(arc_pr) or not layer.can_draw_projectile(rad_pr): failures.append("fallback arcano afeta radiante")
	RadiantOrbVfx._textures[ArcaneOrbVfx.FLIGHT_PATH] = texture
	if not layer.can_draw_projectile(arc_pr): failures.append("voo arcano válido não desenha")
	layer.free()
	return failures

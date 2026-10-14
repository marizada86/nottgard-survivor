extends RefCounted

func run() -> Array[String]:
	var failures: Array[String] = []
	for row in [["golpe_do_juizo","radiante","arco_radiante"],["martelo_da_gloria","radiante","arco_radiante"],["machado_de_xargath","fogo","arco_fogo"],["ruptura_sombria","fisico","ruptura_sombria"]]:
		if MeleeVfx.shape_for(row[0],row[1])!=row[2]: failures.append("dispatch incorreto: "+row[0])
		if not MeleeVfx.shape_for(row[0],"unsupported").is_empty(): failures.append("dtype indevido aceito")
		var event := {"type":"swing","weapon":row[0],"dtype":row[1],"pos":Vector2(20,20),"dir":Vector2.RIGHT,"range":2.4,"cone":85}
		var effect := MeleeVfx.create_effect(event,Color.WHITE)
		if effect==null:
			failures.append("efeito valido ausente")
		else:
			var sprite := effect.get_child(0) as AnimatedSprite2D
			var reach: Vector2 = effect.transform.basis_xform(Vector2(MeleeVfx.CALIBRATED_RADII[row[2]]*sprite.scale.x,0))
			if not reach.is_equal_approx(Iso.to_screen(Vector2.RIGHT*2.4)): failures.append("alcance visual nao coincide com raio calibrado")
			effect.free()
		event.type="active"
		var rejected := MeleeVfx.create_effect(event,Color.WHITE)
		if rejected!=null:
			failures.append("evento active tocou corte duplicado")
			rejected.free()
	if not MeleeVfx.shape_for("esmagar_defesas","radiante").is_empty(): failures.append("icon_like ampliou allowlist")
	var invalid := ImageTexture.create_from_image(Image.create(16,16,false,Image.FORMAT_RGBA8))
	if HeroActiveVfx.frames_from_texture(invalid,12)!=null or HeroActiveVfx.frames_from_texture(null,12)!=null: failures.append("atlas invalido aceito")
	for hero in ["brook","maelor"]:
		var b := Battle.new(233,hero,"dagruve")
		b.hero.hp = 1
		b.events.clear()
		if not b.use_active(): failures.append("ativacao real recusada: "+hero)
		var events := b.events.filter(func(e: Dictionary) -> bool: return e.type=="active")
		if events.size()!=1:
			failures.append("evento active ausente")
			continue
		var hp: float = b.hero.hp
		var rng_state: int = b.rng.state
		var effect := HeroActiveVfx.create_effect(events[0],b,Color.WHITE)
		if effect==null:
			failures.append("efeito real ausente: "+hero)
		else: effect.free()
		if b.hero.hp!=hp or b.rng.state!=rng_state: failures.append("apresentacao modificou simulacao")
		if HeroActiveVfx.create_effect(events[0],b,Color.WHITE,true)!=null: failures.append("reduzido aceitou atlas")
		var wrong: Dictionary = events[0].duplicate()
		wrong.ability_id="concordia"
		if HeroActiveVfx.supports(wrong): failures.append("habilidade cruzada aceita")
		wrong=events[0].duplicate()
		wrong.hero_id="bromnor"
		if HeroActiveVfx.supports(wrong): failures.append("heroi cruzado aceito")
		var frames: SpriteFrames = HeroActiveVfx._frames[hero]
		HeroActiveVfx._frames[hero]=null
		if HeroActiveVfx.create_effect(events[0],b,Color.WHITE)!=null: failures.append("cache ausente nao usa fallback")
		HeroActiveVfx._frames[hero]=frames
	return failures

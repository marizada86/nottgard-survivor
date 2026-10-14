extends RefCounted

func run() -> Array[String]:
	var failures: Array[String]=[]
	for hero in ["sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor"]:
		var b:=Battle.new(571,hero,"dagruve")
		b.hero.pos=Vector2(20,20)
		b.spawn_for_test("zumbi",Vector2(21,20))
		b.enemies[-1].hp=10000
		b.events.clear()
		var origin:=b.hero.pos
		if not b.use_active(Vector2.RIGHT):
			failures.append("ativacao real recusada: "+hero)
			continue
		var qualifying:=b.events.filter(func(e: Dictionary)->bool:return HeroActiveVfx.supports(e))
		if qualifying.size()!=1:
			failures.append("deve haver um unico atlas por ativacao: "+hero)
			continue
		var event: Dictionary=qualifying[0]
		if hero=="sylas" and event.get("visual_origin")!=origin:failures.append("origem real do dash ausente")
		if hero=="nyrelia" and event.get("visual_target_id")!=b.enemies[0].get_instance_id():failures.append("alvo real do charm ausente")
		if hero=="leoric" and b.projectiles.size()!=8:failures.append("numero de projeteis alterado")
		var rng_state:=b.rng.state
		var hp: float=b.hero.hp
		var event_count:=b.events.size()
		var effect:=HeroActiveVfx.create_effect(event,b,Color.WHITE)
		if hero=="leoric" and effect!=null and effect.radius!=2.0:failures.append("flash de Leoric usa alcance dos projeteis em vez do raio visual2")
		if effect==null:failures.append("efeito qualificado ausente: "+hero)
		else:effect.free()
		if b.rng.state!=rng_state or b.hero.hp!=hp or b.events.size()!=event_count:failures.append("apresentacao altera Battle")
		if HeroActiveVfx.create_effect(event,b,Color.WHITE,true)!=null:failures.append("reduzido criou atlas")
		var wrong:=event.duplicate()
		wrong.type="unsupported"
		if HeroActiveVfx.supports(wrong):failures.append("evento indevido aceito")
		if hero in ["sylas","nyrelia"]:
			wrong=event.duplicate()
			wrong.erase("visual_origin" if hero=="sylas" else "visual_target_id")
			if HeroActiveVfx.create_effect(wrong,b,Color.WHITE)!=null:failures.append("metadado ausente inferido")
		var cached: SpriteFrames=HeroActiveVfx._frames[hero]
		HeroActiveVfx._frames[hero]=null
		if HeroActiveVfx.create_effect(event,b,Color.WHITE)!=null:failures.append("cache ausente nao usa fallback")
		HeroActiveVfx._frames[hero]=cached
		var config: Dictionary=HeroActiveVfx.CONFIG[hero]
		var texture:=load(config.path) as Texture2D
		if texture==null or texture.get_size()!=Vector2(1536,256):failures.append("atlas invalido")
	var invalid:=ImageTexture.create_from_image(Image.create(16,16,false,Image.FORMAT_RGBA8))
	if HeroActiveVfx.frames_from_texture(invalid,12)!=null:failures.append("recurso invalido aceito")
	for hero in ["arlindo","erik","durvall"]:
		var b:=Battle.new(572,hero,"dagruve")
		b.hero.pos=Vector2(20,20)
		b.spawn_for_test("zumbi",Vector2(21,20))
		b.events.clear()
		b.use_active(Vector2.RIGHT)
		if not b.events.filter(func(e: Dictionary)->bool:return HeroActiveVfx.supports(e)).is_empty():failures.append("heroi fora do lote aceito: "+hero)
	return failures

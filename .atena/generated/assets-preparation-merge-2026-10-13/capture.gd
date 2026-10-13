extends Node
## S-004 / S-007: dispara os eventos reais do Battle e confere o que o Run desenha. Capturas em captures/.

const OUT := "res://.atena/generated/assets-preparation-merge-2026-10-13/"
const ABILITIES := {
	"durvall": ["ruptura_sombria", "arc"], "brook": ["guarda_de_lliira", "follow"], "maelor": ["comunhao", "pulse"],
	"sylas": ["passo_pelas_sombras", "trail"], "kayron": ["sobrecarga_mistica", "follow"], "korrak": ["impacto_de_xargath", "pulse"],
	"leoric": ["constelacao", "pulse"], "zynara": ["suspensao_temporal", "pulse"], "bromnor": ["concordia", "pulse"],
}
var report := {"result": "PASS", "projectiles": [], "abilities": [], "fallbacks": {}}

func shot(tag: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	assert(get_viewport().get_texture().get_image().save_png(OUT + "captures/" + tag + ".png") == OK)

func clear_fx(run: Node) -> void:
	for node in run.fx.get_children():
		node.free()

func new_run(hero: String) -> Node:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 4242}
	Game._save_path = "user://vfx-qa-profile.json"
	Game.profile = Profile.new({"name": "VFX QA", "welcome_seen": true})
	for id in Data.table("hqs"):
		Game.profile.data["hqs_seen"][id] = true
	Game.run_hero = hero
	Game.run_stage = "dagruve"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(1.5).timeout
	run.set_process(false)
	run.set_physics_process(false)
	run.camera.position = run.hero_node.position + Vector2(0, -30)
	return run

func projectile_case(run: Node, weapon: String, family: String) -> void:
	clear_fx(run)
	run.battle.projectiles.clear()
	run.battle.events.clear()
	run._proj_vfx.clear()
	var w := Weapon.make(weapon)
	run.battle.spawn_for_test("zumbi", run.battle.hero.pos + Vector2(6.0, 0.0))
	assert(run.battle._fire(w, w.params()))
	assert(not run.battle.projectiles.is_empty())
	run._sync_projectile_vfx()
	var flights: Array = run.fx.get_children().filter(func(n): return n is AnimatedSprite2D)
	assert(flights.size() == run.battle.projectiles.size())
	var f: AnimatedSprite2D = flights[0]
	assert(f.sprite_frames.get_frame_texture(&"default", 0).atlas.resource_path == ProjectileVfx.FAMILIES[StringName(family)].path)
	f.pause()
	f.frame = 1
	await shot("%s-%s-voo" % [family, weapon])
	var steps := 0
	while run.battle.projectiles.size() > 0 and steps < 400:
		run.battle._update_projectiles(0.05)
		run._sync_projectile_vfx()
		steps += 1
	assert(run.battle.projectiles.is_empty())
	var impacts: Array = run.fx.get_children().filter(func(n): return n is Node2D and not (n is AnimatedSprite2D) and n.get_child_count() == 1 and n.get_child(0) is AnimatedSprite2D)
	assert(impacts.size() >= 1)
	var s: AnimatedSprite2D = impacts[0].get_child(0)
	s.pause()
	s.frame = 1
	await shot("%s-%s-impacto" % [family, weapon])
	report.projectiles.append({"weapon": weapon, "family": family, "flight_sprites": flights.size(), "impact_nodes": impacts.size(), "steps": steps})
	run._sync_projectile_vfx()
	clear_fx(run)

func ability_case(hero: String, ability_id: String, kind: String) -> void:
	var run: Node = await new_run(hero)
	run.battle.events.clear()
	run.battle.spawn_for_test("zumbi", run.battle.hero.pos + Vector2(1.2, 0.8))
	clear_fx(run)
	run._active_dir = Vector2(1, 0.4).normalized()
	assert(run.battle.use_active(run._active_dir))
	var ev: Dictionary = run.battle.events.filter(func(e): return e.type == "active")[0]
	assert(String(ev.ability_id) == ability_id)
	run._consume_events()
	run._sync_ability_follow()
	var sprites: Array = []
	var queue: Array = [run.hero_node, run.fx]
	while not queue.is_empty():
		var n: Node = queue.pop_back()
		if n is AnimatedSprite2D and n.sprite_frames != null and n.sprite_frames.has_animation(&"default") and n.sprite_frames.get_frame_count(&"default") == 6:
			var atlas = n.sprite_frames.get_frame_texture(&"default", 0).atlas
			if atlas != null and atlas.resource_path == HeroAbilityVfx.SPECS[ability_id].path:
				sprites.append(n)
		queue.append_array(n.get_children())
	assert(sprites.size() == 1)
	var sp: AnimatedSprite2D = sprites[0]
	sp.pause()
	sp.frame = 2
	await shot("habilidade-%s-pico" % ability_id)
	var rings: Array = run.fx.get_children().filter(func(n): return n is Line2D)
	report.abilities.append({"hero": hero, "ability": ability_id, "kind": kind, "sprites": sprites.size(), "plain_rings_left": rings.size()})
	if kind == "follow":
		if ability_id == "guarda_de_lliira":
			run.battle.active_guard = 0
		else:
			run.battle.active_buff_t = 0.0
		run._sync_ability_follow()
		await get_tree().process_frame
		assert(run._ability_follow.is_empty())
		report.abilities[-1]["freed_when_effect_ends"] = true
	run.queue_free()
	await get_tree().process_frame

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT + "captures"))
	var run: Node = await new_run("leoric")
	for pair in [["raio_de_luz", "orbe_radiante"], ["luz_mais_pura", "orbe_radiante"], ["raio_enfraquecedor", "orbe_arcano"], ["lamina_trovejante", "onda_cortante"], ["tempestade", "onda_cortante"]]:
		await projectile_case(run, pair[0], pair[1])
	# impacto reduzido: o circulo antigo volta e nenhum sprite e criado
	Game.profile.data.settings["reduced_impact"] = true
	run.battle.projectiles.clear()
	run._proj_vfx.clear()
	clear_fx(run)
	var w := Weapon.make("raio_de_luz")
	run.battle.spawn_for_test("zumbi", run.battle.hero.pos + Vector2(6.0, 0.0))
	assert(run.battle._fire(w, w.params()))
	run._sync_projectile_vfx()
	assert(run.fx.get_children().filter(func(n): return n is AnimatedSprite2D).is_empty())
	report.fallbacks["reduced_impact_projectile_uses_old_circle"] = true
	await shot("reduced-impact-projectile")
	Game.profile.data.settings["reduced_impact"] = false
	run.queue_free()
	await get_tree().process_frame
	for hero in ABILITIES:
		await ability_case(hero, ABILITIES[hero][0], ABILITIES[hero][1])
	# Nyrelia: o sigilo vem do evento de texto no alvo
	var nyrelia: Node = await new_run("nyrelia")
	nyrelia.battle.events.clear()
	nyrelia.battle.spawn_for_test("zumbi", nyrelia.battle.hero.pos + Vector2(2.0, 1.0))
	clear_fx(nyrelia)
	assert(nyrelia.battle.use_active(Vector2(1, 0)))
	nyrelia._consume_events()
	var sigils: Array = nyrelia.fx.get_children().filter(func(n): return n is Node2D and n.get_child_count() == 1 and n.get_child(0) is AnimatedSprite2D)
	assert(sigils.size() == 1)
	var ss: AnimatedSprite2D = sigils[0].get_child(0)
	assert(ss.sprite_frames.get_frame_texture(&"default", 0).atlas.resource_path == HeroAbilityVfx.SPECS["dominacao"].path)
	ss.pause()
	ss.frame = 2
	await shot("habilidade-dominacao-pico")
	report.abilities.append({"hero": "nyrelia", "ability": "dominacao", "kind": "sigil", "sprites": 1, "plain_rings_left": nyrelia.fx.get_children().filter(func(n): return n is Line2D).size()})
	nyrelia.queue_free()
	await get_tree().process_frame
	report["appdata"] = OS.get_environment("APPDATA")
	var file := FileAccess.open(OUT + "runtime-checks.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t") + "\n")
	print("capture PASS: projeteis e habilidades pelos eventos reais")
	get_tree().quit()

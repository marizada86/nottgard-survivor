extends Node
## SPEC-177 R5-C/D: AMOSTRAS (protótipo só desta ferramenta, nenhum arquivo do jogo muda): partículas ambientais (C) e
## gradação de cor (D) por bioma. Para cada fase: base, C, D, C+D.
## godot --path . res://tools/capture_atmosphere_samples.tscn --resolution 1280x720 [-- --stages=dagruve,molor,durao --dir=res://pasta/]

var _dir := "res://.atena/generated/m2-game-feel/r5-cd-amostras/"
var _stages: PackedStringArray = ["dagruve", "molor", "durao"]

## C: cor das partículas, subida (negativo = sobe), deriva lateral, quantidade, tamanho
const PROFILES := {
	"dagruve": {"color": Color(0.78, 0.74, 0.82, 0.55), "vy": 9.0, "vx": 6.0, "amount": 46, "size": 2.4, "name": "cinza lenta de cemitério"},
	"molor": {"color": Color(0.72, 1.0, 0.45, 0.7), "vy": -10.0, "vx": 4.0, "amount": 40, "size": 2.6, "name": "esporos subindo"},
	"durao": {"color": Color(0.55, 0.9, 1.0, 0.6), "vy": -6.0, "vx": 8.0, "amount": 36, "size": 2.2, "name": "fagulhas frias à deriva"},
}
## D: multiplicador de cor, saturação, vinheta
const GRADES := {
	"dagruve": {"tint": Vector3(0.93, 0.94, 1.04), "sat": 0.88, "vig": 0.28},
	"molor": {"tint": Vector3(0.96, 1.05, 0.88), "sat": 1.08, "vig": 0.22},
	"durao": {"tint": Vector3(0.9, 0.99, 1.07), "sat": 0.94, "vig": 0.26},
}
const SHADER := """shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec3 tint = vec3(1.0);
uniform float sat = 1.0;
uniform float vig = 0.0;
void fragment() {
	vec3 c = texture(screen_texture, SCREEN_UV).rgb;
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	c = mix(vec3(l), c, sat) * tint;
	c *= 1.0 - smoothstep(0.35, 0.95, distance(SCREEN_UV, vec2(0.5))) * vig;
	COLOR = vec4(clamp(c, 0.0, 1.0), 1.0);
}"""

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--stages="):
			_stages = argument.trim_prefix("--stages=").split(",")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	for sid in _stages:
		Game.qa_sandbox = true
		Game.qa_launch = {"seed": 12345}
		Game.run_stage = sid
		Game.run_hero = "durvall"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		for _i in 40:   # 4 s: passa a introdução e deixa os inimigos entrarem
			Game.controls.focused = true
			get_tree().paused = false
			await get_tree().create_timer(0.1).timeout
		run.set_process(false)
		run.set_physics_process(false)
		await _shot("%s_0_base" % sid)
		var particles := _make_particles(sid)
		add_child(particles)
		await get_tree().create_timer(0.3).timeout
		await _shot("%s_1_C_atmosfera" % sid)
		particles.visible = false
		var grade := _make_grade(sid)
		add_child(grade)
		await get_tree().create_timer(0.1).timeout
		await _shot("%s_2_D_gradacao" % sid)
		particles.visible = true
		await _shot("%s_3_C_mais_D" % sid)
		particles.queue_free()
		grade.queue_free()
		run.queue_free()
		await get_tree().process_frame
	get_tree().quit()

func _make_particles(sid: String) -> CanvasLayer:
	var p: Dictionary = PROFILES[sid]
	var layer := CanvasLayer.new()
	layer.layer = 2   # TEXT_LAYER: acima do mundo, abaixo da HUD
	var emitter := CPUParticles2D.new()
	emitter.position = Vector2(640, 360)
	emitter.amount = int(p.amount)
	emitter.lifetime = 8.0
	emitter.preprocess = 8.0
	emitter.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	emitter.emission_rect_extents = Vector2(660, 380)
	emitter.direction = Vector2(float(p.vx), float(p.vy)).normalized()
	emitter.spread = 25.0
	emitter.gravity = Vector2.ZERO
	emitter.initial_velocity_min = Vector2(float(p.vx), float(p.vy)).length() * 0.6
	emitter.initial_velocity_max = Vector2(float(p.vx), float(p.vy)).length() * 1.2
	emitter.scale_amount_min = float(p.size) * 0.7
	emitter.scale_amount_max = float(p.size) * 1.4
	emitter.color = p.color
	layer.add_child(emitter)
	return layer

func _make_grade(sid: String) -> CanvasLayer:
	var g: Dictionary = GRADES[sid]
	var layer := CanvasLayer.new()
	layer.layer = 1   # FILTER_LAYER: entre o mundo e a HUD
	var rect := ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader := Shader.new()
	shader.code = SHADER
	var material := ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("tint", g.tint)
	material.set_shader_parameter("sat", float(g.sat))
	material.set_shader_parameter("vig", float(g.vig))
	rect.material = material
	layer.add_child(rect)
	return layer

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])

extends RefCounted

const Prop := preload("res://ui/prop.gd")

func run() -> Array:
	var out: Array = []
	if not is_equal_approx(Prop.texture_draw_y(256.0, 256.0, 80.0), -80.0):
		out.append("textura sem margem deveria manter a base em y=0")
	var padded_y := Prop.texture_draw_y(256.0, 240.0, 80.0)
	if not is_equal_approx(padded_y + 240.0 * 80.0 / 256.0, 0.0):
		out.append("borda visível com transparência inferior deveria tocar y=0")
	var offset_y := Prop.texture_draw_y(256.0, 240.0, 80.0, 3.0)
	if not is_equal_approx(offset_y + 240.0 * 80.0 / 256.0, 3.0):
		out.append("offset visual deveria ser aplicado após a âncora automática")
	var origin := Prop.texture_draw_origin(Vector2(120.0, 80.0), Vector2(0.5, 0.95), 2.0)
	if origin.distance_to(Vector2(-60.0, -74.0)) > 0.001:
		out.append("âncora artística deveria coincidir com o contato lógico")
	var shadow_center_y := Prop.contact_shadow_center_y(0.0, 5.0, 4.0)
	if shadow_center_y + 4.0 > 2.001:
		out.append("sombra dinâmica não pode terminar abaixo do contato visual")
	var prop := Prop.new()
	prop.block_radius = 0.75
	prop.visual_ground_offset = 4.0
	if not is_equal_approx(prop.block_radius, 0.75):
		out.append("offset visual não pode alterar o raio de bloqueio")
	prop.set_grounding_guide(true)
	if not prop.show_grounding_guide:
		out.append("guia de ancoragem deveria ligar apenas quando solicitado pelo QA")
	var texture: Texture2D = load("res://assets/props/rocha_01.png")
	prop._texture_path = "res://assets/props/rocha_01.png"
	var visible_bottom := prop._visible_bottom_px(texture)
	if visible_bottom <= 0.0 or visible_bottom > texture.get_height():
		out.append("base visível da rocha deveria estar dentro da textura")
	var profile := prop._visual_profile()
	if profile.is_empty() or String(profile.get("shadow_mode", "")) != "dynamic":
		out.append("rocha deveria ter ficha visual e sombra dinâmica própria")
	prop.free()
	return out

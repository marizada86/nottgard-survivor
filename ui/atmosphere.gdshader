shader_type canvas_item;
// SPEC-177 R5-D: gradacao leve por fase (multiplicador de cor, saturacao e vinheta). Le o mundo abaixo desta camada;
// a HUD fica acima e nao passa por aqui.
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest, repeat_disable;
uniform vec3 tint = vec3(1.0);
uniform float sat = 1.0;
uniform float vig = 0.0;

void fragment() {
	vec3 c = texture(screen_texture, SCREEN_UV).rgb;
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	c = mix(vec3(l), c, sat) * tint;
	c *= 1.0 - smoothstep(0.35, 0.95, distance(SCREEN_UV, vec2(0.5))) * vig;
	COLOR = vec4(clamp(c, 0.0, 1.0), 1.0);
}

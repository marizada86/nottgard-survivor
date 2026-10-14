shader_type canvas_item;
// SPEC-173 (MEC-065): filtro de tela do mundo. Lê o que já foi desenhado abaixo desta camada (mundo, fundo da fase)
// e devolve a imagem filtrada; a HUD fica numa camada acima e não passa por aqui.
// Tamanhos em "pixels virtuais" de 1280x720: escalam com a altura real da janela, então o aspecto é o mesmo em qualquer resolução.
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest, repeat_disable;
uniform int mode = 0;               // 1 paleta e dither, 2 gravura (o "pixel do mundo" foi descartado pelo dono em 2026-10-13)
uniform float levels = 6.0;         // níveis por canal (modo 1)
uniform float dither = 0.9;         // 0 sem dither, 1 cheio (modo 1)
uniform float edge_threshold = 0.22; // limiar da borda na luminância (modo 2)
uniform float edge_strength = 0.5;  // quanto a borda escurece (modo 2)
uniform float grain = 0.035;        // grão fixo, 0 desliga (modo 2; o impacto reduzido põe 0)
uniform float vignette = 0.35;      // escurecimento dos cantos (modo 2)

const float BAYER[16] = float[16](0.0, 8.0, 2.0, 10.0, 12.0, 4.0, 14.0, 6.0, 3.0, 11.0, 1.0, 9.0, 15.0, 7.0, 13.0, 5.0);

float luma(vec3 c) {
	return dot(c, vec3(0.299, 0.587, 0.114));
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
	float k = res.y / 720.0;
	vec3 col = texture(screen_texture, SCREEN_UV).rgb;
	if (mode == 1) {
		int bx = int(mod(floor(FRAGCOORD.x / max(k, 1.0)), 4.0));
		int by = int(mod(floor(FRAGCOORD.y / max(k, 1.0)), 4.0));
		float threshold = (BAYER[bx + by * 4] + 0.5) / 16.0;
		float steps = max(levels - 1.0, 1.0);
		float bias = mix(0.5, threshold, clamp(dither, 0.0, 1.0));
		col = floor(col * steps + bias) / steps;
	} else if (mode == 2) {
		vec2 o = vec2(k) / res;
		float l = luma(texture(screen_texture, SCREEN_UV + vec2(o.x, 0.0)).rgb);
		float r = luma(texture(screen_texture, SCREEN_UV - vec2(o.x, 0.0)).rgb);
		float u = luma(texture(screen_texture, SCREEN_UV + vec2(0.0, o.y)).rgb);
		float d = luma(texture(screen_texture, SCREEN_UV - vec2(0.0, o.y)).rgb);
		float edge = smoothstep(edge_threshold, edge_threshold * 2.0, abs(l - r) + abs(u - d));
		col *= 1.0 - edge * edge_strength;
		col += (hash(floor(FRAGCOORD.xy / max(k, 1.0))) - 0.5) * grain;
		float dist = distance(SCREEN_UV, vec2(0.5));
		col *= 1.0 - smoothstep(0.35, 0.9, dist) * vignette;
	}
	COLOR = vec4(clamp(col, 0.0, 1.0), 1.0);
}

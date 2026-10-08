shader_type canvas_item;
// SPEC-132 (MEC-049): gradiente vertical de ouro para Label de lettering.
// Multiplica a cor do glifo (a fonte vai em branco; contorno e sombra, escuros, continuam escuros).
// Usa a posição local em vez de UV: em texto, UV é a região do atlas da fonte, não do glifo.
uniform vec4 top_color : source_color = vec4(1.0, 0.93, 0.68, 1.0);
uniform vec4 bottom_color : source_color = vec4(0.78, 0.56, 0.24, 1.0);
uniform float y0 = 0.0;
uniform float span = 48.0;
varying float local_y;

void vertex() {
	local_y = VERTEX.y;
}

void fragment() {
	COLOR.rgb *= mix(top_color.rgb, bottom_color.rgb, clamp((local_y - y0) / max(span, 1.0), 0.0, 1.0));
}

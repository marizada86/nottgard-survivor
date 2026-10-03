extends SceneTree
## Reprojeta um decal de estrada para o losango isométrico 2:1 exato do jogo (arestas com inclinação 1/2),
## para que trechos vizinhos e o eixo x/y (espelho) se encaixem sem degraus nem cruzamentos tortos.
## Mede o paralelogramo da arte pelas retas de contorno e o mapeia afim para o losango ideal, mantendo o centro e o comprimento em x.
## Uso: godot --headless --path . -s res://tools/reproject_road_tile.gd -- [--write] res://assets/decals/arquivo.png

const ALPHA_THRESHOLD := 0.3
## Janelas (fração da largura) para medir as inclinações: topo/base das arestas longas, topo/base das curtas.
var forced_slopes := Vector2.ZERO
var fit := [0.31, 0.69, 0.06, 0.62, 0.02, 0.24, 0.76, 0.94]

func _initialize() -> void:
	var write := false
	var path := ""
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--slopes="):
			var pair := arg.substr(9).split(",")
			forced_slopes = Vector2(float(pair[0]), float(pair[1]))
		elif arg.begins_with("--fit="):
			fit = Array(arg.substr(6).split(",")).map(func(s): return float(s))
		elif arg == "--write":
			write = true
		else:
			path = arg
	var image := Image.new()
	if image.load(ProjectSettings.globalize_path(path)) != OK:
		push_error("não abriu %s" % path)
		quit(1)
		return
	image.convert(Image.FORMAT_RGBA8)
	var size := image.get_size()
	# Inclinações medidas das arestas longas (u) e curtas (v) da arte.
	var slope_u := 0.0
	var slope_v := 0.0
	var slopes := _fit_slopes(image)
	slope_u = slopes.u
	slope_v = slopes.v
	if forced_slopes != Vector2.ZERO:
		slope_u = forced_slopes.x
		slope_v = forced_slopes.y
	# Extremos nas direções a = y - slope_u*x (constante nas arestas longas) e b = y - slope_v*x (arestas curtas).
	var a_min := 1e9
	var a_max := -1e9
	var b_min := 1e9
	var b_max := -1e9
	for y in size.y:
		for x in size.x:
			if image.get_pixel(x, y).a < ALPHA_THRESHOLD:
				continue
			var a := y - slope_u * x
			var b := y - slope_v * x
			a_min = minf(a_min, a)
			a_max = maxf(a_max, a)
			b_min = minf(b_min, b)
			b_max = maxf(b_max, b)
	# Cantos = interseções das retas extremas. Vetor u = ao longo da aresta longa; v = ao longo da curta.
	var origin := _intersect(a_min, b_min, slope_u, slope_v)  # canto topo
	var along_u := _intersect(a_min, b_max, slope_u, slope_v) - origin  # topo -> esquerda? (ao longo de b=cte? ver abaixo)
	var corner_c := _intersect(a_max, b_min, slope_u, slope_v)
	var across := corner_c - origin
	print("inclinações u=%.3f v=%.3f  topo=%s  d1=%s  d2=%s" % [slope_u, slope_v, origin, along_u, across])
	# Escolhe como "longo" (u_s) o vetor com |x| maior e positivo; "curto" (v_s) o outro, apontando para baixo-esquerda.
	var u_s := across if absf(across.x) > absf(along_u.x) else along_u
	var v_s := along_u if absf(across.x) > absf(along_u.x) else across
	if u_s.x < 0.0:
		u_s = -u_s
	if v_s.y < 0.0:
		v_s = -v_s
	var center_s := origin + (u_s + v_s) * 0.5
	var u_d := Vector2(u_s.x, u_s.x * 0.5)
	var v_d := Vector2(-absf(v_s.x), absf(v_s.x) * 0.5)
	print("u_s=%s v_s=%s -> u_d=%s v_d=%s centro_fonte=%s" % [u_s, v_s, u_d, v_d, center_s])
	var center_d := Vector2(size) * 0.5
	# destino -> fonte: p - c_d = s*u_d + t*v_d  =>  q = c_s + s*u_s + t*v_s
	var det := u_d.x * v_d.y - u_d.y * v_d.x
	var out := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	for y in size.y:
		for x in size.x:
			var d := Vector2(x + 0.5, y + 0.5) - center_d
			var s := (d.x * v_d.y - d.y * v_d.x) / det
			var t := (u_d.x * d.y - u_d.y * d.x) / det
			var q := center_s + u_s * s + v_s * t
			out.set_pixel(x, y, _sample(image, q - Vector2(0.5, 0.5)))
	if write:
		out.save_png(ProjectSettings.globalize_path(path))
		print("gravado ", path)
	quit()

func _intersect(a: float, b: float, slope_u: float, slope_v: float) -> Vector2:
	# y - su*x = a ; y - sv*x = b
	var x := (b - a) / (slope_u - slope_v)
	return Vector2(x, a + slope_u * x)

## Ajusta as duas inclinações dominantes pelas bordas esquerda/direita por linha (arestas longas) e topo/base por coluna... simplificado: usa regressão das bordas.
func _fit_slopes(image: Image) -> Dictionary:
	var size := image.get_size()
	# aresta longa inferior-esquerda: menor x por linha; aresta longa superior-direita: maior x por linha.
	var left_pts: Array[Vector2] = []
	var right_pts: Array[Vector2] = []
	var top_pts: Array[Vector2] = []
	var bottom_pts: Array[Vector2] = []
	for y in size.y:
		var l := -1
		var r := -1
		for x in size.x:
			if image.get_pixel(x, y).a >= ALPHA_THRESHOLD:
				if l < 0:
					l = x
				r = x
		if l >= 0:
			left_pts.append(Vector2(l, y))
			right_pts.append(Vector2(r, y))
	for x in size.x:
		var t := -1
		var b := -1
		for y in size.y:
			if image.get_pixel(x, y).a >= ALPHA_THRESHOLD:
				if t < 0:
					t = y
				b = y
		if t >= 0:
			top_pts.append(Vector2(x, t))
			bottom_pts.append(Vector2(x, b))
	# Arestas longas: topo (esquerda->direita, descendo) e base. Arestas curtas: laterais.
	var su := (_slope(_middle(top_pts, fit[0], fit[1])) + _slope(_middle(bottom_pts, fit[2], fit[3]))) * 0.5
	var sv := (_slope(_middle(top_pts, fit[4], fit[5])) + _slope(_middle(bottom_pts, fit[6], fit[7]))) * 0.5
	return {"u": su, "v": sv}

func _middle(points: Array[Vector2], from_fraction: float, to_fraction: float, _by_y := false) -> Array[Vector2]:
	var result: Array[Vector2] = []
	var count := points.size()
	for i in range(int(count * from_fraction), int(count * to_fraction)):
		result.append(points[i])
	return result

func _slope(points: Array[Vector2]) -> float:
	# regressão dy/dx
	var n := float(points.size())
	if n < 2.0:
		return 0.5
	var mx := 0.0
	var my := 0.0
	for p in points:
		mx += p.x
		my += p.y
	mx /= n
	my /= n
	var num := 0.0
	var den := 0.0
	for p in points:
		num += (p.x - mx) * (p.y - my)
		den += (p.x - mx) * (p.x - mx)
	return num / maxf(den, 1e-6)

func _sample(image: Image, p: Vector2) -> Color:
	var x0 := int(floor(p.x))
	var y0 := int(floor(p.y))
	var fx := p.x - x0
	var fy := p.y - y0
	var acc := Color(0, 0, 0, 0)
	for j in 2:
		for i in 2:
			var px := x0 + i
			var py := y0 + j
			if px < 0 or py < 0 or px >= image.get_width() or py >= image.get_height():
				continue
			var w := (fx if i == 1 else 1.0 - fx) * (fy if j == 1 else 1.0 - fy)
			var c := image.get_pixel(px, py)
			acc += Color(c.r * c.a * w, c.g * c.a * w, c.b * c.a * w, c.a * w)
	if acc.a <= 0.001:
		return Color(0, 0, 0, 0)
	return Color(acc.r / acc.a, acc.g / acc.a, acc.b / acc.a, acc.a)

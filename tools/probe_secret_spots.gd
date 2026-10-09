extends SceneTree
## SPEC-157: mapa ASCII do chão de uma fase para escolher os pontos dos segredos.
## godot --headless --path . -s tools/probe_secret_spots.gd -- dagruve 60
## Legenda: '#' bloqueado, '~' água, 'o' destrutível/armadilha/interativo da cena de dados, '.' livre, 'H' início.
func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	var stage := String(args[0])
	var side := int(args[1])
	TerrainLayout.scale = float(side) / 40.0
	var b := Battle.new(5, "durvall", stage)
	b.map_size = Vector2(side, side)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	b.stage.waves = []
	b.stage.elites = []
	b.place_scenery()
	var marks := {}
	for e in b.enemies:
		marks[Vector2i(int(e.pos.x / 2.0), int(e.pos.y / 2.0))] = "o"
	for i in b.interactions:
		marks[Vector2i(int(i.pos.x / 2.0), int(i.pos.y / 2.0))] = "o"
	print("%s %dx%d, início %s" % [stage, side, side, str(b.hero.pos)])
	var header := "    "
	for gx in range(0, side, 2):
		header += "%d" % ((gx / 10) % 10) if gx % 10 == 0 else " "
	print(header)
	for gy in range(0, side, 2):
		var row := "%3d " % gy
		for gx in range(0, side, 2):
			var p := Vector2(gx + 1.0, gy + 1.0)
			var ch := "."
			if TerrainLayout.is_styx_water(stage, p):
				ch = "~"
			elif TerrainLayout.is_blocked(stage, p) or not b.hero.can_stand(p, 0.3):
				ch = "#"
			if marks.has(Vector2i(gx / 2, gy / 2)):
				ch = "o"
			if absf(p.x - b.hero.pos.x) < 1.1 and absf(p.y - b.hero.pos.y) < 1.1:
				ch = "H"
			row += ch
		print(row)
	quit()

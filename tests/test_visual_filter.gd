extends RefCounted
## SPEC-173 (MEC-065): filtro visual de tela: valores, migração do perfil, custo zero desligado, camadas e opção.
## Não grava no save real: não chama Game.set_visual_filter (que salva), só o Profile e o nó isolados.

func run() -> Array:
	var out: Array = []

	# valores aceitos e padrão
	if VisualFilter.MODES != ["off", "paleta", "gravura"] or VisualFilter.LABELS.size() != VisualFilter.MODES.size():
		out.append("modos e rótulos fora do combinado: %s / %s" % [str(VisualFilter.MODES), str(VisualFilter.LABELS)])
	if Game.VISUAL_FILTERS != VisualFilter.MODES:
		out.append("Game.VISUAL_FILTERS divergiu de VisualFilter.MODES")
	for bad in [null, "", "sepia", 3, "PIXEL", "pixel"]:  # "pixel" foi descartado: perfis com ele voltam para off
		if VisualFilter.normalize(bad) != "off":
			out.append("valor %s deveria virar off" % str(bad))
	for good in VisualFilter.MODES:
		if VisualFilter.normalize(good) != good:
			out.append("modo válido %s não foi preservado" % good)

	# migração do perfil: ausente, inválido e válido
	if String(Profile.fresh().settings.get("visual_filter", "?")) != "off":
		out.append("perfil novo deveria nascer com visual_filter = off")
	var legacy := Profile.new({"settings": {"volume": 0.5}})
	if String(legacy.data.settings.get("visual_filter", "?")) != "off":
		out.append("perfil antigo sem a chave deveria ficar em off")
	var invalid := Profile.new({"settings": {"visual_filter": "sepia"}})
	if String(invalid.data.settings.visual_filter) != "off":
		out.append("valor inválido no perfil deveria virar off")
	var dropped := Profile.new({"settings": {"visual_filter": "pixel"}})
	if String(dropped.data.settings.visual_filter) != "off":
		out.append("perfil com o pixel descartado deveria voltar para off")
	var valid := Profile.new({"settings": {"visual_filter": "gravura"}})
	if String(valid.data.settings.visual_filter) != "gravura":
		out.append("valor válido no perfil não foi preservado")

	# shader compila e expõe os parâmetros
	var uniforms: Array = []
	for u in VisualFilter.SHADER.get_shader_uniform_list(true):
		uniforms.append(String(u.name))
	for need in ["mode", "levels", "dither", "edge_threshold", "edge_strength", "grain", "vignette"]:
		if not (need in uniforms):
			out.append("o shader não expõe o parâmetro %s (compilou?)" % need)

	# desligado não desenha e não carrega material; ligado desenha
	var filter := VisualFilter.new()
	filter.apply({})
	if filter.is_drawing() or filter.shader_material() != null or filter.mode != "off":
		out.append("sem a chave o filtro deveria estar desligado e sem material")
	filter.apply({"visual_filter": "paleta"})
	if not filter.is_drawing() or filter.shader_material() == null:
		out.append("paleta deveria desenhar com material")
	elif int(filter.shader_material().get_shader_parameter("mode")) != 1:
		out.append("paleta deveria usar o modo 1 do shader")
	var seen := {}
	for i in range(1, VisualFilter.MODES.size()):
		filter.apply({"visual_filter": VisualFilter.MODES[i]})
		var m := int(filter.shader_material().get_shader_parameter("mode"))
		if seen.has(m):
			out.append("dois modos usando o mesmo modo do shader (%d)" % m)
		seen[m] = true
	# impacto reduzido tira o grão
	filter.apply({"visual_filter": "gravura"})
	if float(filter.shader_material().get_shader_parameter("grain")) <= 0.0:
		out.append("gravura sem impacto reduzido deveria ter grão")
	filter.apply({"visual_filter": "gravura", "reduced_impact": true})
	if float(filter.shader_material().get_shader_parameter("grain")) != 0.0:
		out.append("impacto reduzido deveria tirar o grão da gravura")
	filter.apply({"visual_filter": "off"})
	if filter.is_drawing() or filter.shader_material() != null:
		out.append("voltar para off deveria soltar o material")
	filter.free()

	# camadas: mundo (0) < filtro < texto do mundo < HUD < camada de encontros (20, ui/run.gd)
	if not (0 < VisualFilter.FILTER_LAYER and VisualFilter.FILTER_LAYER < VisualFilter.TEXT_LAYER and VisualFilter.TEXT_LAYER < VisualFilter.HUD_LAYER and VisualFilter.HUD_LAYER < 20):
		out.append("camadas fora de ordem: filtro %d, texto %d, HUD %d" % [VisualFilter.FILTER_LAYER, VisualFilter.TEXT_LAYER, VisualFilter.HUD_LAYER])
	var run_source := FileAccess.get_file_as_string("res://ui/run.gd")
	for needle in ["hud.layer = VisualFilter.HUD_LAYER", "_text_layer.layer = VisualFilter.TEXT_LAYER", "_text_fx.add_child(l)", "over.split_text = true", "_visual_filter.apply(Game.profile.data.settings)", "_encounter_layer.layer = 20", "visual_settings_changed.connect"]:
		if not run_source.contains(needle):
			out.append("ui/run.gd perdeu a ligação do filtro: %s" % needle)
	if not Game.has_signal("visual_settings_changed"):
		out.append("Game sem o sinal visual_settings_changed")

	# a opção existe no OptionsPanel, com os quatro valores, e reflete o perfil
	var panel := OptionsPanel.new()
	if panel.visual == null or panel.visual.item_count != VisualFilter.MODES.size():
		out.append("OptionsPanel sem a opção Visual com %d valores" % VisualFilter.MODES.size())
	panel.free()
	return out

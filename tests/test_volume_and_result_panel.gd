extends RefCounted
## BUG-044: mexer no volume não reaplica a janela nem grava o save a cada passo.
## BUG-045: a tela de resultado cabe na tela com muitas conquistas e toda conquista diz o que dá.

func run() -> Array:
	var out: Array = []
	_volume(out)
	_result(out)
	return out

func _volume(out: Array) -> void:
	var tree := Engine.get_main_loop() as SceneTree
	var panel := OptionsPanel.new()
	tree.root.add_child(panel)
	panel.refresh()
	var windows_before: int = Game.window_apply_count
	for i in 20:
		panel.master_vol.value = 0.05 * (i % 19)
		panel.music_vol.value = 0.05 * ((i + 3) % 19)
		panel.sfx_vol.value = 0.05 * ((i + 7) % 19)
		panel.ambience_vol.value = 0.05 * ((i + 11) % 19)
	if Game.window_apply_count != windows_before:
		out.append("mexer nos volumes reaplicou a janela %d vez(es); deveria ser 0" % (Game.window_apply_count - windows_before))
	if not panel.save_pending:
		out.append("o save deveria ficar pendente (gravado uma vez, depois dos passos)")
	panel.flush_save()
	if panel.save_pending:
		out.append("flush_save deveria zerar o pendente")
	# mudar o modo de tela continua reaplicando a janela
	var windows_mid: int = Game.window_apply_count
	var mode := String(Game.profile.data.settings.get("window_mode", "windowed"))
	Game.set_window_mode(mode)
	if Game.window_apply_count != windows_mid + 1:
		out.append("trocar o modo de tela deveria reaplicar a janela uma vez")
	panel.free()

func _result(out: Array) -> void:
	var tree := Engine.get_main_loop() as SceneTree
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	var achievements: Array = Data.table("achievements").achievements
	var ids: Array = []
	for a in achievements:
		ids.append(a.id)
		if ids.size() >= 16:
			break
	var res := {"won": false, "dead": true, "extracted": false, "hero": "durvall", "stage": "molor", "time": 2170.0,
		"level": 28, "kills": 2477, "bosses": 3, "descent_depth": 3, "reward_mult": 1.9, "abyss_level": 0}
	var summary := {"earned": 1403, "reward_rate": 0.5, "coins": 2666, "achievements": ids}
	hud.show_result(res, summary)
	var viewport_height: float = hud.get_viewport().get_visible_rect().size.y
	var panel: Control = hud.result_panel
	if panel.size.y > viewport_height:
		out.append("o painel de resultado (%.0f px) passa da tela (%.0f px)" % [panel.size.y, viewport_height])
	var again: Control = hud.get_node("%AgainBtn")
	var bottom: float = again.get_global_rect().end.y
	if bottom > viewport_height:
		out.append("o botão Jogar de novo termina em %.0f, abaixo da tela (%.0f)" % [bottom, viewport_height])
	var top: float = hud.result_title.get_global_rect().position.y
	if top < 0.0:
		out.append("o título do resultado começa acima da tela (%.0f)" % top)
	if hud.result_text.get_parent() is not ScrollContainer:
		out.append("a lista do resultado deveria rolar dentro de um ScrollContainer")
	# conquistas só de moedas dizem o que dão
	var intocado := {"name": "Intocado", "reward": {"coins": 100}}
	var line: String = hud.achievement_line(intocado)
	if not line.contains("100 moedas"):
		out.append("conquista só de moedas deveria mostrar as moedas: '%s'" % line)
	var texto := {"name": "Veterano", "reward": {"text": "+2 PV máximos"}}
	if hud.achievement_line(texto) != "★ Veterano — +2 PV máximos":
		out.append("conquista com texto deveria manter o texto")
	var vazio := {"name": "Sem nada", "reward": {}}
	if hud.achievement_line(vazio).ends_with("—"):
		out.append("recompensa vazia não deveria deixar um travessão solto")
	hud.free()

extends RefCounted
## M2 R5 (SPEC-177, opções A e B): vinheta de vida baixa e golpe recebido; tamanho dos números que não são acerto.

func run() -> Array:
	var out: Array = []
	# histerese: entra abaixo de 30%, só sai acima de 36%
	if DangerFeedback.is_low(0.31, false):
		out.append("31% não deveria entrar em vida baixa")
	if not DangerFeedback.is_low(0.29, false):
		out.append("29% deveria entrar em vida baixa")
	if not DangerFeedback.is_low(0.33, true):
		out.append("33% já em vida baixa deveria continuar (histerese)")
	if DangerFeedback.is_low(0.37, true):
		out.append("37% deveria sair da vida baixa")
	# vinheta: invisível com vida boa, mais forte quanto menor a vida, estática com impacto reduzido
	if DangerFeedback.low_alpha(false, 0.1, 0.0, false) != 0.0:
		out.append("sem vida baixa a vinheta deveria ser 0")
	if DangerFeedback.low_alpha(true, 0.05, 0.0, true) <= DangerFeedback.low_alpha(true, 0.28, 0.0, true):
		out.append("a vinheta deveria crescer com a vida menor")
	var still_a := DangerFeedback.low_alpha(true, 0.15, 0.0, true)
	var still_b := DangerFeedback.low_alpha(true, 0.15, 0.4, true)
	if not is_equal_approx(still_a, still_b):
		out.append("com impacto reduzido a vinheta não deveria pulsar")
	var pulse_a := DangerFeedback.low_alpha(true, 0.15, 0.0, false)
	var pulse_b := DangerFeedback.low_alpha(true, 0.15, DangerFeedback.PULSE_PERIOD * 0.25, false)
	if is_equal_approx(pulse_a, pulse_b):
		out.append("sem impacto reduzido a vinheta deveria pulsar")
	for f in [0.0, 0.1, 0.29]:
		if DangerFeedback.low_alpha(true, f, DangerFeedback.PULSE_PERIOD * 0.25, false) > DangerFeedback.MAX_ALPHA:
			out.append("a vinheta passa do teto de opacidade")
	# flash de golpe
	if DangerFeedback.flash_peak(5.0, 40.0, true, false) != 0.0:
		out.append("dano contínuo não deveria flashar")
	if DangerFeedback.flash_peak(5.0, 40.0, false, true) != 0.0:
		out.append("impacto reduzido não deveria flashar")
	if DangerFeedback.flash_peak(0.0, 40.0, false, false) != 0.0:
		out.append("golpe sem dano não deveria flashar")
	if DangerFeedback.flash_peak(20.0, 40.0, false, false) <= DangerFeedback.flash_peak(2.0, 40.0, false, false):
		out.append("golpe maior deveria flashar mais")
	if DangerFeedback.flash_peak(400.0, 40.0, false, false) > 0.45:
		out.append("o flash tem teto de 0,45")
	var peak := DangerFeedback.flash_peak(10.0, 40.0, false, false)
	if DangerFeedback.flash_alpha(peak, 0.0) != peak or DangerFeedback.flash_alpha(peak, DangerFeedback.FLASH_SECONDS) != 0.0:
		out.append("o flash deveria começar no pico e acabar em %.2f s" % DangerFeedback.FLASH_SECONDS)
	if DangerFeedback.flash_alpha(peak, 0.1) <= DangerFeedback.flash_alpha(peak, 0.2):
		out.append("o flash deveria decair")
	# nó
	var v := DangerVignette.new()
	if v.mouse_filter != Control.MOUSE_FILTER_IGNORE:
		out.append("a vinheta não pode capturar o mouse")
	v.tick(0.1, 0.9, true, false)
	if v.visible or v.alpha() != 0.0:
		out.append("com vida boa a vinheta deveria estar invisível")
	for i in 120:
		v.tick(1.0 / 60.0, 0.1, true, false)
	if not v.is_low() or v.alpha() <= 0.12:
		out.append("com 10%% de vida a vinheta deveria estar ligada (alpha %.2f)" % v.alpha())
	for i in 120:   # recupera para 50%: sai e some
		v.tick(1.0 / 60.0, 0.5, true, false)
	if v.is_low() or v.visible:
		out.append("com 50%% de vida a vinheta deveria ter saído")
	v.on_hurt(10.0, 40.0, false, false)
	v.tick(0.0, 0.9, true, false)
	if v.alpha() < 0.17:
		out.append("o golpe recebido deveria acender o flash (alpha %.2f)" % v.alpha())
	for i in 30:
		v.tick(1.0 / 60.0, 0.9, true, false)
	if v.alpha() != 0.0:
		out.append("o flash deveria ter apagado em 0,5 s (alpha %.2f)" % v.alpha())
	v.on_hurt(10.0, 40.0, true, false)
	v.tick(0.0, 0.9, true, false)
	if v.alpha() != 0.0:
		out.append("dano contínuo não deveria acender o flash")
	v.on_hurt(10.0, 40.0, false, false)
	v.tick(0.0, 0.9, false, false)   # partida terminada
	if v.alpha() != 0.0:
		out.append("fora da partida a vinheta deveria sumir")
	v.free()
	# B: números que não são acerto
	if DamageFeedback.HURT_SIZE < 20 or DamageFeedback.HEAL_SIZE < 16 or DamageFeedback.CUE_SIZE < 14:
		out.append("números de dano recebido, cura e aviso abaixo do tamanho de M2 R5")
	if DamageFeedback.HURT_SIZE <= DamageFeedback.number_size(0, false):
		out.append("o dano recebido deveria ser maior que o acerto comum")
	for b in 4:
		if DamageFeedback.outline_size(b) < 5:
			out.append("contorno da faixa %d abaixo de 5 px" % b)
	return out

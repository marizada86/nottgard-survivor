extends VBoxContainer
## Ranking publico; uploads Windows continuam exclusivamente pelas evidencias.
const SITE := "https://marizverso.com"
var _mode: OptionButton
var _groups: OptionButton
var _status: Label
var _list: RichTextLabel
var _request: HTTPRequest
var _callback: JavaScriptObject
var _sequence := 0
var _board := ""
var _boards: Array = []

func _ready() -> void:
	name = "Ranking"
	var title := Label.new()
	title.text = "Ranking de playtest"
	title.add_theme_font_size_override("font_size", 24)
	add_child(title)
	var controls := HBoxContainer.new()
	add_child(controls)
	_mode = OptionButton.new()
	for text in ["Pontos", "Sobrevivencia", "Conclusao rapida"]:
		_mode.add_item(text)
	_mode.custom_minimum_size.y = 48
	_mode.item_selected.connect(func(_i): _board = ""; refresh())
	controls.add_child(_mode)
	var update := Button.new()
	update.text = "Atualizar"
	update.custom_minimum_size.y = 48
	update.pressed.connect(refresh)
	controls.add_child(update)
	_groups = OptionButton.new()
	_groups.custom_minimum_size.y = 48
	_groups.item_selected.connect(func(i): _board = String(_boards[i].id); refresh())
	add_child(_groups)
	_status = Label.new()
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status.text = "Atualize para ver pontos e tempos. Somente testers aprovados; QA e velocidade extra ficam fora."
	add_child(_status)
	_list = RichTextLabel.new()
	_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_list.bbcode_enabled = false
	_list.focus_mode = Control.FOCUS_ALL
	add_child(_list)
	_request = HTTPRequest.new()
	_request.timeout = 15
	_request.request_completed.connect(_received)
	add_child(_request)
	var info := Label.new()
	info.text = "1 por comum · 10 por elite · 100 por chefe · 500 por fase unica. Objetos e ouro nao pontuam."
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(info)
	var full := Button.new()
	full.text = "Ver builds e ranking completo no site"
	full.pressed.connect(func():
		if OS.has_feature("web"):
			JavaScriptBridge.eval("window.open('/playtest/ranking','_blank','noopener')")
		else:
			OS.shell_open(SITE + "/playtest/ranking"))
	add_child(full)

func refresh() -> void:
	_sequence += 1
	_status.text = "Carregando ranking..."
	var mode: String = ["score", "survival", "speed"][_mode.selected]
	var endpoint := "/api/playtest/leaderboard?mode=" + mode + ("&board=" + _board.uri_encode() if _board != "" else "")
	if OS.has_feature("web"):
		if _callback == null:
			_callback = JavaScriptBridge.create_callback(_web_received)
			JavaScriptBridge.get_interface("window").nottgardLeaderboardReceipt = _callback
		JavaScriptBridge.eval("fetch(%s,{credentials:'same-origin',signal:AbortSignal.timeout(15000)}).then(r=>{if(!r.ok)throw Error();return r.json()}).then(d=>window.nottgardLeaderboardReceipt?.(%d,JSON.stringify(d))).catch(()=>window.nottgardLeaderboardReceipt?.(%d,'{}'));" % [JSON.stringify(endpoint), _sequence, _sequence])
	else:
		_request.cancel_request()
		if _request.request(SITE + endpoint) != OK:
			_status.text = "Ranking indisponivel. Tente novamente."

func _received(result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		_status.text = "Ranking indisponivel. Tente novamente."
		return
	show_data(JSON.parse_string(body.get_string_from_utf8()))

func _web_received(args: Array) -> void:
	if args.size() == 2 and int(args[0]) == _sequence:
		show_data(JSON.parse_string(String(args[1])))

func show_data(data: Variant) -> void:
	if not data is Dictionary or not data.get("ok", false):
		_status.text = "Ranking indisponivel. Tente novamente."
		return
	_groups.clear()
	_boards = data.get("boards", [])
	_board = String(data.get("board", ""))
	for i in _boards.size():
		var b: Dictionary = _boards[i]
		_groups.add_item("%s · %s · dificuldade %s · progresso %s" % [b.hero, b.stage, b.difficulty, b.progress])
		if b.id == _board:
			_groups.select(i)
	var lines: Array[String] = []
	for entry in data.get("entries", []):
		lines.append("#%d  %s  ·  %d pontos  ·  %02d:%02d" % [int(entry.rank), String(entry.player), int(entry.score), int(entry.active_seconds) / 60, int(entry.active_seconds) % 60])
	_list.text = "\n\n".join(lines)
	_status.text = "Melhor partida por jogador neste grupo." if not lines.is_empty() else "Ainda nao ha resultados recebidos."

func _exit_tree() -> void:
	if OS.has_feature("web") and _callback != null:
		JavaScriptBridge.eval("window.nottgardLeaderboardReceipt = undefined")

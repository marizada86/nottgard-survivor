extends RefCounted

const GameScript := preload("res://core/game.gd")
const ProfileScript := preload("res://core/profile.gd")
const ROOT := "res://tmp/test-save-resilience"

func run() -> Array:
	var failures: Array[String] = []
	_prepare_root()
	var primary := ROOT + "/profile.json"
	var backup := GameScript.profile_backup_path(primary)
	var game := GameScript.new()
	game._save_path = primary
	game.profile = ProfileScript.new({"coins": 17})
	game.save()
	_assert_valid(failures, primary, 17, "primeiro save")
	game.profile.data.coins = 42
	game.save()
	_assert_valid(failures, primary, 42, "save promovido")
	_assert_valid(failures, backup, 17, "backup da versão anterior")

	_write(primary, "{")
	var recovered := GameScript.new()
	recovered._save_path = primary
	recovered.load_profile()
	if recovered.profile.coins() != 17:
		failures.append("save corrompido deveria recuperar moedas do backup")
	if recovered.save_notice.find("recuperado") < 0:
		failures.append("recuperação do backup deveria informar o jogador")
	if not FileAccess.file_exists(primary) or bool(GameScript.read_profile_file(primary).valid):
		failures.append("carregamento não pode sobrescrever o save corrompido")
	recovered.profile.data.coins = 55
	recovered.save()
	_assert_valid(failures, primary, 55, "save após recuperação")
	if not FileAccess.file_exists(primary + ".corrupt"):
		failures.append("save corrompido deveria ser preservado para diagnóstico")

	var broken_primary := ROOT + "/broken.json"
	var broken_backup := GameScript.profile_backup_path(broken_primary)
	_write(broken_primary, "{")
	_write(broken_backup, "[")
	var broken := GameScript.new()
	broken._save_path = broken_primary
	broken.load_profile()
	if broken.profile.coins() != 0 or broken.persisted:
		failures.append("dois arquivos inválidos devem abrir um perfil novo apenas em memória")
	if not FileAccess.file_exists(broken_primary) or not FileAccess.file_exists(broken_backup):
		failures.append("carregamento não pode apagar saves inválidos")

	var guard := GameScript.new()
	var real_before := guard.real_save_signature()
	var sandbox_primary := ROOT + "/qa-sandbox/profile.json"
	var sandbox := GameScript.new()
	sandbox._save_path = sandbox_primary
	sandbox.profile = ProfileScript.new({"coins": 9})
	sandbox.save()
	_assert_valid(failures, sandbox_primary, 9, "save isolado de QA")
	if guard.real_save_signature() != real_before:
		failures.append("save isolado de QA não pode alterar o save real")
	_cleanup()
	return failures

func _assert_valid(failures: Array[String], path: String, coins: int, label: String) -> void:
	var loaded := GameScript.read_profile_file(path)
	if not bool(loaded.valid) or int(loaded.data.get("coins", -1)) != coins:
		failures.append("%s deveria conter perfil válido com %d moedas" % [label, coins])

func _write(path: String, text: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(text)
	file.close()

func _prepare_root() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(ROOT + "/qa-sandbox"))
	_cleanup_files()

func _cleanup() -> void:
	_cleanup_files()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(ROOT + "/qa-sandbox"))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(ROOT))

func _cleanup_files() -> void:
	for name in ["profile.json", "profile.json.bak", "profile.json.tmp", "profile.json.bak.tmp", "profile.json.corrupt", "broken.json", "broken.json.bak", "broken.json.tmp", "broken.json.bak.tmp", "qa-sandbox/profile.json", "qa-sandbox/profile.json.bak", "qa-sandbox/profile.json.tmp", "qa-sandbox/profile.json.bak.tmp"]:
		var path: String = ROOT + "/" + String(name)
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

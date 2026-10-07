extends RefCounted
const Record := preload("res://core/run_record.gd")

func run() -> Array:
	var failures: Array = []
	var points := Record.score({"common": 2, "elite": 1, "boss": 1}, ["dagruve", "dagruve"])
	if points.total != 612:
		failures.append("score deveria separar categorias e contar cada fase uma vez")
	var b := Battle.new(128, "durvall", "dagruve", {})
	var before: int = b.rng.state
	b.run_record.begin(b, {}, "windows", true)
	if b.rng.state != before:
		failures.append("iniciar estatistica alterou RNG do combate")
	b.run_record.hit("test", 50, 10)
	if b.run_record.damage.test.effective != 10 or b.run_record.damage.test.overkill != 40:
		failures.append("dano efetivo inclui overkill")
	b.run_record.mark("accelerated")
	b.run_record.checkpoint(b, "choice", {"secret": "never-export", "id": "test"})
	var result := b.run_record.snapshot(b, "dead")
	var json := JSON.stringify(result)
	if json.contains("never-export") or result.run_id.length() != 32:
		failures.append("schema vazou segredo ou ID nao foi gerado")
	if not result.eligibility_reasons.has("qa") or not result.eligibility_reasons.has("accelerated"):
		failures.append("QA/aceleracao precisam persistir no resultado")
	if JSON.parse_string(json) == null or result.history.size() < 2:
		failures.append("resultado nao serializa ou historico esta ausente")
	return failures

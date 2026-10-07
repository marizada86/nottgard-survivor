extends SceneTree
## Produz duas amostras sinteticas com o mesmo produtor usado no jogo.
func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var lines := ""
	for origin in ["web", "windows"]:
		var b := Battle.new(128, "durvall", "dagruve", {"difficulty": 1, "meta_mods": {}})
		b.run_record.begin(b, {"meta_mods": {}, "difficulty": 1, "task_id": "general"}, origin, true)
		b.run_record.mark("accelerated")
		var common: String = String(Data.table("stages").dagruve.waves[0].id)
		var e = b.spawn_for_test(common, b.hero.pos + Vector2(3, 0))
		b.run_record.hit("test:weapon", 50, e.hp)
		b._kill(e)
		b.run_time = 120
		b.run_record.checkpoint(b, "checkpoint")
		lines += JSON.stringify(b.run_record.snapshot(b, "dead")) + "\n"
	var file := FileAccess.open("res://.atena/generated/playtest-ranking/v01/godot-synthetic.log", FileAccess.WRITE)
	file.store_string(lines)
	file.close()
	print("interop: duas amostras sinteticas geradas")
	quit()

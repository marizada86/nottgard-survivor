extends SceneTree
## Promove somente decais aprovados de biomas com área seca declarada.

const SOURCE_ROOT := "res://.atena/generated/art-candidates/scenery-normalized"
const DESTINATION_ROOT := "res://assets/decals"
const STAGES := ["dagruve", "shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis", "pilares"]
const KINDS := ["remendo", "trilha"]

func _init() -> void:
	for stage_id in STAGES:
		for kind in KINDS:
			var source := "%s/%s/%s_%s_01_v01.png" % [SOURCE_ROOT, stage_id, stage_id, kind]
			var destination := "%s/%s_%s_01.png" % [DESTINATION_ROOT, stage_id, kind]
			if not FileAccess.file_exists(source):
				printerr("candidata ausente: %s" % source)
				quit(1)
				return
			if FileAccess.file_exists(destination):
				printerr("destino já existe; promoção não sobrescreve assets: %s" % destination)
				quit(1)
				return
			DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(destination.get_base_dir()))
			if DirAccess.copy_absolute(ProjectSettings.globalize_path(source), ProjectSettings.globalize_path(destination)) != OK:
				printerr("falha ao promover: %s" % destination)
				quit(1)
				return
	print("decais promovidos: %d" % (STAGES.size() * KINDS.size()))
	quit()

extends SceneTree

func _init() -> void:
	var package: String = get_script().resource_path.get_base_dir()
	var target := package.path_join("qa-userdata")
	ProjectSettings.set_setting("application/config/use_custom_user_dir", true)
	ProjectSettings.set_setting("application/config/custom_user_dir_name", "../../.codex/worktrees/ffff/nottgard-survivor/.atena/generated/art032-implementation-2026-10-12/qa-userdata")
	print("Requested data directory: " + target)
	print("Resolved user data: " + OS.get_user_data_dir().simplify_path())
	if OS.get_user_data_dir().simplify_path() != target.simplify_path():
		print("Custom userdata cannot target this workspace; do not create/delete directories.")
		quit(1)
		return
	quit(0)

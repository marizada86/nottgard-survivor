class_name MachineInfo
extends RefCounted
## PLAN-099 (SPEC-172): o que o relatório de playtest precisa saber da máquina para interpretar "travou aqui".
## Sem nome de usuário, pasta, host nem identificador de máquina.

const WINDOW_MODES := {0: "janela", 1: "minimizada", 2: "maximizada", 3: "tela cheia", 4: "tela cheia exclusiva"}

static func describe() -> Dictionary:
	var mem := OS.get_memory_info()
	var window := DisplayServer.window_get_size()
	var screen := DisplayServer.screen_get_size()
	var hz := DisplayServer.screen_get_refresh_rate()
	return {
		"so": ("%s %s" % [OS.get_name(), OS.get_version()]).strip_edges(),
		"cpu": OS.get_processor_name(),
		"nucleos": OS.get_processor_count(),
		"ram_mb": int(int(mem.get("physical", 0)) / 1048576),
		"gpu": RenderingServer.get_video_adapter_name(),
		"gpu_fornecedor": RenderingServer.get_video_adapter_vendor(),
		"renderer": RenderingServer.get_current_rendering_method(),
		"driver": RenderingServer.get_current_rendering_driver_name(),
		"janela": "%dx%d" % [window.x, window.y],
		"tela": "%dx%d" % [screen.x, screen.y],
		"hz": int(round(hz)) if hz > 0.0 else 0,
		"modo": String(WINDOW_MODES.get(int(DisplayServer.window_get_mode()), "?")),
		"godot": String(Engine.get_version_info().get("string", "")),
		"web": OS.has_feature("web"),
	}

## Uma linha: "Windows 10 | Intel i5 (4 nucleos) | 8192 MB | Intel UHD | gl_compatibility/opengl3 | 1280x720 em 1920x1080 @60 Hz".
static func short() -> String:
	var d := describe()
	var gpu := String(d.gpu) if String(d.gpu) != "" else "GPU desconhecida"
	return "%s | %s (%d nucleos) | %d MB | %s | %s/%s | %s em %s @%d Hz | %s" % [d.so, String(d.cpu), int(d.nucleos), int(d.ram_mb), gpu,
		d.renderer, d.driver, d.janela, d.tela, int(d.hz), d.modo]

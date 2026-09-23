extends RefCounted

func run() -> Array:
	var out: Array = []
	if Version.VERSION == "":
		out.append("VERSION vazio")
	if Version.profile_from_features([]) != Version.BuildProfile.PRODUCTION:
		out.append("build sem feature precisa ser producao")
	if Version.profile_from_features(["public_playtest"]) != Version.BuildProfile.PUBLIC_PLAYTEST:
		out.append("feature public_playtest nao selecionou perfil publico")
	if Version.profile_from_features(["qa_internal"]) != Version.BuildProfile.QA_INTERNAL:
		out.append("feature qa_internal nao selecionou perfil QA")
	if Version.profile_from_features(["public_playtest", "qa_internal"]) != Version.BuildProfile.PRODUCTION:
		out.append("features conflitantes precisam falhar para producao")
	return out

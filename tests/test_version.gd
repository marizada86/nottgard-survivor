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
	if Version.profile_from_features([], true) != Version.BuildProfile.QA_INTERNAL:
		out.append("execucao de depuracao precisa liberar o perfil QA")
	if Version.profile_from_features(["public_playtest"], true) != Version.BuildProfile.PUBLIC_PLAYTEST:
		out.append("playtest publico precisa prevalecer sobre o modo de depuracao")
	if not Version.qa_enabled_for_profile(Version.BuildProfile.QA_INTERNAL):
		out.append("Navegador QA deve estar habilitado no perfil QA interno")
	if Version.qa_enabled_for_profile(Version.BuildProfile.PUBLIC_PLAYTEST):
		out.append("Navegador QA nao deve aparecer no playtest publico")
	if Version.qa_enabled_for_profile(Version.BuildProfile.PRODUCTION):
		out.append("Navegador QA nao deve aparecer na producao")
	if not Version.playtest_tools_enabled_for_profile(Version.BuildProfile.PUBLIC_PLAYTEST):
		out.append("build de playtest precisa expor as ferramentas autorizadas")
	if Version.build_id() == "":
		out.append("build_id nunca pode ser vazio")
	if Version.playtest_tools_enabled_for_profile(Version.BuildProfile.PRODUCTION):
		out.append("producao nao pode expor ferramentas de playtest")
	return out

class_name Version
extends RefCounted

const VERSION := "0.2.0"
const GAME_NAME := "Nottgard Survivors"

enum BuildProfile { PRODUCTION, PUBLIC_PLAYTEST, QA_INTERNAL }

static func profile_from_features(features: Array, debug_tools: bool = false) -> int:
	var public_enabled := features.has("public_playtest")
	var qa_enabled := features.has("qa_internal")
	if public_enabled and qa_enabled:
		return BuildProfile.PRODUCTION
	if qa_enabled:
		return BuildProfile.QA_INTERNAL
	if public_enabled:
		return BuildProfile.PUBLIC_PLAYTEST
	return BuildProfile.QA_INTERNAL if debug_tools else BuildProfile.PRODUCTION

static func build_profile() -> int:
	var features: Array = []
	if OS.has_feature("public_playtest"):
		features.append("public_playtest")
	if OS.has_feature("qa_internal"):
		features.append("qa_internal")
	return profile_from_features(features, OS.is_debug_build() and not OS.has_feature("headless"))

static func evidence_enabled() -> bool:
	return playtest_tools_enabled_for_profile(build_profile())

static func playtest_tools_enabled_for_profile(profile: int) -> bool:
	return profile == BuildProfile.PUBLIC_PLAYTEST or profile == BuildProfile.QA_INTERNAL

static func qa_enabled() -> bool:
	return qa_enabled_for_profile(build_profile())

static func qa_enabled_for_profile(profile: int) -> bool:
	return profile == BuildProfile.QA_INTERNAL

static func profile_slug() -> String:
	return "qa" if qa_enabled() else "public" if evidence_enabled() else "production"

## Identificador da build (hash curto do commit), gravado por tools/stamp_build.ps1 ou pelo CI
## em data/build_info.json. Sem o arquivo, é uma execução local: "dev".
const BUILD_INFO_PATH := "res://data/build_info.json"

static func build_id() -> String:
	if not FileAccess.file_exists(BUILD_INFO_PATH):
		return "dev"
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(BUILD_INFO_PATH))
	if typeof(parsed) != TYPE_DICTIONARY:
		return "dev"
	var commit := str((parsed as Dictionary).get("commit", "")).strip_edges()
	return commit if commit != "" else "dev"

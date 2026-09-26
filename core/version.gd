class_name Version
extends RefCounted

const VERSION := "0.1.0"
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
	return build_profile() != BuildProfile.PRODUCTION

static func qa_enabled() -> bool:
	return build_profile() == BuildProfile.QA_INTERNAL

static func profile_slug() -> String:
	return "qa" if qa_enabled() else "public" if evidence_enabled() else "production"

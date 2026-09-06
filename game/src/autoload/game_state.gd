extends Node

signal progress_changed
signal settings_changed

const SAVE_SCHEMA_VERSION := 1
const SAVE_PATH := "user://jianghu_verdict_v1.json"
const TEMP_PATH := "user://jianghu_verdict_v1.tmp"
const BACKUP_PATH := "user://jianghu_verdict_v1.bak"

var case_index := 0
var unlocked_case := 0
var verdicts: Dictionary = {}
var exposed_claims: Dictionary = {}
var reputation := {
	"trust": 0,
	"fear": 0,
	"benevolence": 0,
	"corruption": 0,
}
var settings := {
	"master_volume": 0.8,
	"reduced_motion": false,
	"large_text": false,
}
var save_exists := false


func _ready() -> void:
	load_game()
	apply_settings()


func start_new_game() -> void:
	case_index = 0
	unlocked_case = 0
	verdicts.clear()
	exposed_claims.clear()
	reputation = {
		"trust": 0,
		"fear": 0,
		"benevolence": 0,
		"corruption": 0,
	}
	save_exists = true
	save_game()
	progress_changed.emit()


func record_case_result(
	case_id: String,
	selected_verdict: Dictionary,
	exposed: Array[String],
	total_cases: int,
) -> void:
	if verdicts.has(case_id):
		return
	verdicts[case_id] = selected_verdict["id"]
	exposed_claims[case_id] = exposed.duplicate()
	var effects: Dictionary = selected_verdict["effects"]
	for axis in reputation:
		reputation[axis] = int(reputation[axis]) + int(effects.get(axis, 0))
	unlocked_case = mini(unlocked_case + 1, total_cases - 1)
	case_index = unlocked_case
	save_exists = true
	save_game()
	progress_changed.emit()


func update_setting(key: String, value: Variant) -> void:
	if not settings.has(key):
		push_error("Unknown setting: %s" % key)
		return
	settings[key] = value
	apply_settings()
	save_game()
	settings_changed.emit()


func ending_id() -> String:
	if int(reputation["corruption"]) >= 5:
		return "puppet"
	if int(reputation["fear"]) >= 7 and int(reputation["fear"]) > int(reputation["trust"]):
		return "iron"
	return "breaker"


func apply_settings() -> void:
	var master_bus := AudioServer.get_bus_index("Master")
	if master_bus >= 0:
		var volume := clampf(float(settings["master_volume"]), 0.0, 1.0)
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(maxf(volume, 0.001)))


func save_game() -> bool:
	var payload := {
		"schema_version": SAVE_SCHEMA_VERSION,
		"case_index": case_index,
		"unlocked_case": unlocked_case,
		"verdicts": verdicts,
		"exposed_claims": exposed_claims,
		"reputation": reputation,
		"settings": settings,
	}
	var file := FileAccess.open(TEMP_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Unable to create temporary save file")
		return false
	file.store_string(JSON.stringify(payload, "\t"))
	file.flush()
	file.close()

	var save_absolute := ProjectSettings.globalize_path(SAVE_PATH)
	var temp_absolute := ProjectSettings.globalize_path(TEMP_PATH)
	var backup_absolute := ProjectSettings.globalize_path(BACKUP_PATH)
	if FileAccess.file_exists(BACKUP_PATH):
		DirAccess.remove_absolute(backup_absolute)
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.rename_absolute(save_absolute, backup_absolute)
	var result := DirAccess.rename_absolute(temp_absolute, save_absolute)
	if result != OK:
		push_error("Unable to promote save: %s" % error_string(result))
		return false
	save_exists = true
	return true


func load_game() -> bool:
	var payload := _read_save(SAVE_PATH)
	if payload.is_empty():
		payload = _read_save(BACKUP_PATH)
	if payload.is_empty() or int(payload.get("schema_version", -1)) != SAVE_SCHEMA_VERSION:
		save_exists = false
		return false
	case_index = int(payload.get("case_index", 0))
	unlocked_case = int(payload.get("unlocked_case", 0))
	verdicts = payload.get("verdicts", {})
	exposed_claims = payload.get("exposed_claims", {})
	var loaded_reputation: Dictionary = payload.get("reputation", {})
	for axis in reputation:
		reputation[axis] = int(loaded_reputation.get(axis, 0))
	var loaded_settings: Dictionary = payload.get("settings", {})
	for key in settings:
		if loaded_settings.has(key):
			settings[key] = loaded_settings[key]
	save_exists = true
	return true


func _read_save(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

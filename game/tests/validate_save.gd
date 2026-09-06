extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	var campaign := CampaignRepository.load_campaign()
	var cases: Array = campaign["cases"]
	game_state.start_new_game()
	var case_data := cases[0] as Dictionary
	var verdict := case_data["verdicts"][0] as Dictionary
	var exposed: Array[String] = ["C101"]
	game_state.record_case_result(
		case_data["id"],
		verdict,
		exposed,
		cases.size(),
	)
	game_state.update_setting("master_volume", 0.35)
	game_state.update_setting("large_text", true)
	assert(game_state.save_game())

	game_state.case_index = 0
	game_state.unlocked_case = 0
	game_state.verdicts.clear()
	game_state.reputation["trust"] = 0
	game_state.settings["master_volume"] = 1.0
	game_state.settings["large_text"] = false

	assert(game_state.load_game())
	assert(game_state.unlocked_case == 1)
	assert(game_state.verdicts.has(case_data["id"]))
	assert(game_state.reputation["trust"] == 2)
	assert(is_equal_approx(float(game_state.settings["master_volume"]), 0.35))
	assert(bool(game_state.settings["large_text"]))
	print(JSON.stringify({
		"schema_version": game_state.SAVE_SCHEMA_VERSION,
		"unlocked_case": game_state.unlocked_case,
		"verdicts": game_state.verdicts,
		"settings_restored": true,
	}))
	quit(0)

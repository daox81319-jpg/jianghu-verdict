extends SceneTree


func _initialize() -> void:
	var game_state := root.get_node("GameState")
	var campaign := CampaignRepository.load_campaign()
	var cases: Array = campaign["cases"]
	var scenarios := {
		"breaker": [0, 0, 0, 0],
		"iron": [2, 1, 1, 1],
		"puppet": [1, 2, 2, 2],
	}
	var results := {}

	for expected_ending in scenarios:
		game_state.start_new_game()
		var choices: Array = scenarios[expected_ending]
		for case_index in cases.size():
			var case_data := cases[case_index] as Dictionary
			var verdict := case_data["verdicts"][choices[case_index]] as Dictionary
			var exposed: Array[String] = []
			for claim_id in case_data["required_claims"]:
				exposed.append(str(claim_id))
			game_state.record_case_result(
				case_data["id"],
				verdict,
				exposed,
				cases.size(),
			)
		assert(game_state.ending_id() == expected_ending)
		results[expected_ending] = game_state.reputation.duplicate()

	print(JSON.stringify({
		"endings": results,
		"validated": scenarios.size(),
	}))
	quit(0)

extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node("GameState")
	game_state.start_new_game()
	var packed := load("res://scenes/main.tscn") as PackedScene
	assert(packed != null)
	var main := packed.instantiate()
	root.add_child(main)
	await process_frame

	var cases: Array = main.get("cases")
	assert(cases.size() == 4)
	for case_index in cases.size():
		main.start_case(case_index)
		main.call("_enter_hearing")
		var case_data := main.get("current_case") as Dictionary
		var exposed_before: Array = main.get("exposed_claim_ids")
		assert(exposed_before.is_empty())
		for required_id in case_data["required_claims"]:
			var claim_index := _index_by_id(case_data["claims"], required_id)
			var claim := case_data["claims"][claim_index] as Dictionary
			var evidence_index := _index_by_id(
				case_data["evidence"],
				(claim["contradicted_by"] as Array)[0],
			)
			main.call("_select_evidence", evidence_index)
			main.call("_challenge_claim", claim_index)
		assert((main.get("exposed_claim_ids") as Array).size() == (case_data["required_claims"] as Array).size())
		assert(main.get_node("GameUI/Hearing/VerdictReady").visible)
		main.call("_show_verdict")
		main.call("_select_verdict", 0)
		main.call("_confirm_verdict")
		assert(game_state.verdicts.has(case_data["id"]))
		assert(main.get_node("GameUI/ResultScreen").visible)
		main.call("_continue_after_result")

	assert(game_state.verdicts.size() == 4)
	assert(main.get_node("GameUI/EndingScreen").visible)
	assert(game_state.ending_id() == "breaker")
	print(JSON.stringify({
		"completed_cases": game_state.verdicts.size(),
		"ending": game_state.ending_id(),
		"reputation": game_state.reputation,
	}))
	paused = false
	for audio in main.find_children("*", "AudioStreamPlayer", true, false):
		(audio as AudioStreamPlayer).stop()
	main.free()
	packed = null
	call_deferred("_finish")


func _index_by_id(items: Array, target_id: String) -> int:
	for index in items.size():
		if str((items[index] as Dictionary)["id"]) == target_id:
			return index
	return -1


func _finish() -> void:
	await process_frame
	quit(0)

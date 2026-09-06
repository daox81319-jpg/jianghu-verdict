extends SceneTree

const DESIGN_SIZE := Vector2i(1600, 900)
const OUTPUT_SIZE := Vector2i(1280, 720)


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.content_scale_size = DESIGN_SIZE
	root.size = OUTPUT_SIZE
	var game_state := root.get_node("GameState")
	game_state.save_exists = false

	var packed := load("res://scenes/main.tscn") as PackedScene
	assert(packed != null)
	var main := packed.instantiate()
	for audio in main.find_children("*", "AudioStreamPlayer", true, false):
		(audio as AudioStreamPlayer).stream = null
	root.add_child(main)
	await process_frame

	var ui := main.get_node("GameUI")
	await _click(ui.get_node("TitleScreen/Menu/NewGame"))
	assert(ui.get_node("BriefScreen").visible)
	assert(game_state.save_exists)
	await _settle()

	await _click(ui.get_node("BriefScreen/Content/Begin"))
	assert(ui.get_node("Hearing").visible)
	await _settle()

	await _click(ui.get_node("Hearing/EvidencePanel/Content/Evidence1"))
	assert(str(main.get("selected_evidence_id")) == "E101")

	await _click(ui.get_node("Hearing/ClaimsPanel/Content/Claim1"))
	assert((main.get("exposed_claim_ids") as Array).has("C101"))
	assert(ui.get_node("Hearing/VerdictReady").visible)

	await _click(ui.get_node("Hearing/VerdictReady"))
	assert(ui.get_node("VerdictScreen").visible)
	await _settle()

	await _click(ui.get_node("VerdictScreen/Content/Verdict1"))
	assert(str((main.get("selected_verdict") as Dictionary)["id"]) == "V101")
	assert(ui.get_node("VerdictScreen/Content/Confirm").visible)

	await _click(ui.get_node("VerdictScreen/Content/Confirm"))
	assert(ui.get_node("ResultScreen").visible)
	assert(game_state.verdicts.get("C01_RAIN_LEDGER") == "V101")
	print(JSON.stringify({
		"case": "C01_RAIN_LEDGER",
		"mouse_steps": 7,
		"result_screen": true,
		"verdict": game_state.verdicts["C01_RAIN_LEDGER"],
		"viewport": [OUTPUT_SIZE.x, OUTPUT_SIZE.y],
	}))

	paused = false
	main.queue_free()
	packed = null
	await process_frame
	await process_frame
	quit(0)


func _click(control: Control) -> void:
	var center := control.get_global_rect().get_center()
	var window_position := center * Vector2(OUTPUT_SIZE) / Vector2(DESIGN_SIZE)
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.position = window_position
	event.global_position = window_position
	event.pressed = true
	Input.parse_input_event(event)
	await process_frame
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	await process_frame


func _settle() -> void:
	await create_timer(0.12, true, false, true).timeout
	await process_frame

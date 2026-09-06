extends SceneTree

const OUTPUT_ROOT := "res://../artifacts/ui"
const DESIGN_SIZE := Vector2i(1600, 900)
const OUTPUT_SIZE := Vector2i(1280, 720)


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var output_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	var mkdir_error := DirAccess.make_dir_recursive_absolute(output_dir)
	assert(mkdir_error == OK)

	root.content_scale_size = DESIGN_SIZE
	root.size = OUTPUT_SIZE
	var game_state := root.get_node("GameState")
	game_state.start_new_game()
	game_state.settings["reduced_motion"] = true
	game_state.settings["large_text"] = false

	var packed := load("res://scenes/main.tscn") as PackedScene
	assert(packed != null)
	var main := packed.instantiate()
	for audio in main.find_children("*", "AudioStreamPlayer", true, false):
		(audio as AudioStreamPlayer).stream = null
	root.add_child(main)
	await process_frame
	await _capture("01_title")

	main.start_case(0)
	await _settle()
	await _capture("02_case_brief")

	main.call("_enter_hearing")
	await _settle()
	await _capture("03_hearing")

	main.call("_select_evidence", 0)
	await _settle()
	await _capture("04_evidence_selected")

	main.call("_challenge_claim", 0)
	await _settle()
	await _capture("05_contradiction")

	main.call("_show_verdict")
	main.call("_select_verdict", 0)
	await _settle()
	await _capture("06_verdict")

	main.call("_confirm_verdict")
	await _settle()
	await _capture("07_result")

	game_state.reputation = {
		"trust": 11,
		"fear": 0,
		"benevolence": 5,
		"corruption": -2,
	}
	main.call("_show_ending")
	await _settle()
	await _capture("08_ending_breaker")

	main.show_title()
	main.call("_show_case_select")
	await _settle()
	await _capture("09_case_select")

	main.show_title()
	main.call("_show_settings")
	await _settle()
	await _capture("10_settings")

	game_state.settings["large_text"] = true
	main.call("_apply_accessibility")
	await _settle()
	await _capture("11_settings_large_text")

	main.start_case(0)
	main.call("_enter_hearing")
	main.call("_show_pause")
	await _settle()
	await _capture("12_pause_large_text")

	game_state.settings["large_text"] = false
	main.call("_apply_accessibility")
	main.start_case(1)
	await _settle()
	await _capture("13_case2_brief")

	main.start_case(3)
	await _settle()
	await _capture("14_final_case_brief")
	main.call("_enter_hearing")
	await _settle()
	await _capture("15_final_case_hearing")

	print(JSON.stringify({
		"captures": 15,
		"output": output_dir,
		"design_size": [DESIGN_SIZE.x, DESIGN_SIZE.y],
		"viewport": [OUTPUT_SIZE.x, OUTPUT_SIZE.y],
	}))
	paused = false
	for audio in main.find_children("*", "AudioStreamPlayer", true, false):
		(audio as AudioStreamPlayer).stop()
		(audio as AudioStreamPlayer).stream = null
	main.queue_free()
	packed = null
	await process_frame
	await process_frame
	quit(0)


func _settle() -> void:
	await create_timer(0.12, true, false, true).timeout
	await process_frame


func _capture(name: String) -> void:
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	assert(image != null and not image.is_empty())
	assert(image.get_width() == OUTPUT_SIZE.x)
	assert(image.get_height() == OUTPUT_SIZE.y)
	var path := ProjectSettings.globalize_path("%s/%s.png" % [OUTPUT_ROOT, name])
	var save_error := image.save_png(path)
	assert(save_error == OK)

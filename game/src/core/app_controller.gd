extends Node3D

const CHARACTER_BY_FACTION := {
	"刀客门": "JV_CH_BladeEnvoy",
	"毒门": "JV_CH_PoisonEnvoy",
	"无相禅院": "JV_CH_MonkEnvoy",
	"江湖令府": "JV_CH_Mastermind",
}

@onready var hall: Node3D = $JudgmentHall
@onready var camera: Camera3D = $Camera3D
@onready var ai_gateway: AiGateway = $AiGateway
@onready var ui: CanvasLayer = $GameUI
@onready var audio_ui: AudioStreamPlayer = $Audio/UISelect
@onready var audio_evidence: AudioStreamPlayer = $Audio/Evidence
@onready var audio_contradiction: AudioStreamPlayer = $Audio/Contradiction
@onready var audio_seal: AudioStreamPlayer = $Audio/Seal
@onready var audio_result: AudioStreamPlayer = $Audio/Result
@onready var audio_ambient: AudioStreamPlayer = $Audio/Ambient

var campaign: Dictionary = {}
var cases: Array = []
var current_case_index := 0
var current_case: Dictionary = {}
var selected_evidence_id := ""
var exposed_claim_ids: Array[String] = []
var selected_verdict: Dictionary = {}
var attempt_index := 0
var _pending_fallback: Dictionary = {}
var _character_roots: Dictionary = {}
var _evidence_buttons: Array[Button] = []
var _claim_buttons: Array[Button] = []
var _verdict_buttons: Array[Button] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_flag(
			DisplayServer.WINDOW_FLAG_EXCLUDE_FROM_CAPTURE,
			false,
		)
	campaign = CampaignRepository.load_campaign()
	if campaign.is_empty():
		return
	cases = campaign["cases"]
	_collect_character_roots()
	_collect_buttons()
	_connect_ui()
	ai_gateway.performance_ready.connect(_on_performance_ready)
	audio_ambient.finished.connect(audio_ambient.play)
	if DisplayServer.get_name() != "headless":
		audio_ambient.play()
	_apply_accessibility()
	show_title()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if ui.get_node("PauseScreen").visible:
			_resume()
		elif ui.get_node("Hearing").visible:
			_show_pause()
		else:
			show_title()
		return
	if not ui.get_node("Hearing").visible:
		return
	if event.is_action_pressed("quick_evidence_1"):
		_select_evidence(0)
	elif event.is_action_pressed("quick_evidence_2"):
		_select_evidence(1)
	elif event.is_action_pressed("quick_evidence_3"):
		_select_evidence(2)
	elif event.is_action_pressed("restart_case"):
		start_case(current_case_index)


func _collect_buttons() -> void:
	_evidence_buttons.assign([
		ui.get_node("Hearing/EvidencePanel/Content/Evidence1"),
		ui.get_node("Hearing/EvidencePanel/Content/Evidence2"),
		ui.get_node("Hearing/EvidencePanel/Content/Evidence3"),
	])
	_claim_buttons.assign([
		ui.get_node("Hearing/ClaimsPanel/Content/Claim1"),
		ui.get_node("Hearing/ClaimsPanel/Content/Claim2"),
		ui.get_node("Hearing/ClaimsPanel/Content/Claim3"),
	])
	_verdict_buttons.assign([
		ui.get_node("VerdictScreen/Content/Verdict1"),
		ui.get_node("VerdictScreen/Content/Verdict2"),
		ui.get_node("VerdictScreen/Content/Verdict3"),
	])
	for index in _evidence_buttons.size():
		_evidence_buttons[index].pressed.connect(_select_evidence.bind(index))
	for index in _claim_buttons.size():
		_claim_buttons[index].pressed.connect(_challenge_claim.bind(index))
	for index in _verdict_buttons.size():
		_verdict_buttons[index].pressed.connect(_select_verdict.bind(index))


func _connect_ui() -> void:
	ui.get_node("TitleScreen/Menu/Continue").pressed.connect(
		func(): start_case(GameState.case_index)
	)
	ui.get_node("TitleScreen/Menu/NewGame").pressed.connect(_new_game)
	ui.get_node("TitleScreen/Menu/Cases").pressed.connect(_show_case_select)
	ui.get_node("TitleScreen/Menu/Settings").pressed.connect(_show_settings)
	ui.get_node("TitleScreen/Menu/Quit").pressed.connect(func(): get_tree().quit())
	ui.get_node("BriefScreen/Content/Begin").pressed.connect(_enter_hearing)
	ui.get_node("Hearing/VerdictReady").pressed.connect(_show_verdict)
	ui.get_node("VerdictScreen/Content/Confirm").pressed.connect(_confirm_verdict)
	ui.get_node("ResultScreen/Content/Continue").pressed.connect(_continue_after_result)
	ui.get_node("EndingScreen/Content/TitleButton").pressed.connect(show_title)
	ui.get_node("CaseSelectScreen/Content/Back").pressed.connect(show_title)
	ui.get_node("SettingsScreen/Panel/Content/Back").pressed.connect(show_title)
	ui.get_node("PauseScreen/Content/Resume").pressed.connect(_resume)
	ui.get_node("PauseScreen/Content/Restart").pressed.connect(
		func():
			_resume()
			start_case(current_case_index)
	)
	ui.get_node("PauseScreen/Content/TitleButton").pressed.connect(show_title)
	ui.get_node("SettingsScreen/Panel/Content/Volume").value_changed.connect(
		func(value: float): GameState.update_setting("master_volume", value)
	)
	ui.get_node("SettingsScreen/Panel/Content/ReducedMotion").toggled.connect(
		func(enabled: bool): GameState.update_setting("reduced_motion", enabled)
	)
	ui.get_node("SettingsScreen/Panel/Content/LargeText").toggled.connect(
		func(enabled: bool):
			GameState.update_setting("large_text", enabled)
			_apply_accessibility()
	)
	for index in cases.size():
		ui.get_node("CaseSelectScreen/Content/Case%d" % (index + 1)).pressed.connect(
			start_case.bind(index)
		)
	for button in ui.find_children("*", "Button", true, false):
		(button as Button).pressed.connect(_play_audio.bind(audio_ui))


func _collect_character_roots() -> void:
	for root_name in CHARACTER_BY_FACTION.values():
		var node := hall.find_child(root_name, true, false) as Node3D
		if node:
			_character_roots[root_name] = node
			node.visible = false


func show_title() -> void:
	_hide_all_screens()
	ui.get_node("TitleScreen").visible = true
	var continue_button := ui.get_node("TitleScreen/Menu/Continue") as Button
	continue_button.disabled = not GameState.save_exists
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_hide_characters()


func _new_game() -> void:
	GameState.start_new_game()
	start_case(0)


func start_case(index: int) -> void:
	current_case_index = clampi(index, 0, cases.size() - 1)
	current_case = (cases[current_case_index] as Dictionary).duplicate(true)
	GameState.case_index = current_case_index
	GameState.save_game()
	_hide_all_screens()
	var brief := ui.get_node("BriefScreen")
	brief.visible = true
	brief.get_node("Content/Chapter").text = current_case["chapter"]
	brief.get_node("Content/Title").text = current_case["title"]
	brief.get_node("Content/Kicker").text = current_case["kicker"]
	brief.get_node("Content/Summary").text = current_case["summary"]
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_configure_character()
	_play_transition()


func _enter_hearing() -> void:
	selected_evidence_id = ""
	exposed_claim_ids.clear()
	selected_verdict.clear()
	attempt_index = 0
	_hide_all_screens()
	var character := _visible_character()
	if character:
		character.position = Vector3.ZERO
	var hearing := ui.get_node("Hearing")
	hearing.visible = true
	hearing.get_node("TopBar/Row/CaseTitle").text = (
		"%s · %s" % [current_case["chapter"], current_case["title"]]
	)
	hearing.get_node("TopBar/Row/Reputation").text = _reputation_text()
	hearing.get_node("Subtitle/Content/NpcName").text = current_case["npc"]
	hearing.get_node("Subtitle/Content/NpcRole").text = current_case["role"]
	hearing.get_node("Subtitle/Content/NpcText").text = current_case["opening"]
	hearing.get_node("EvidencePanel/Content/Detail").text = "先从左侧选择一件证物。"
	hearing.get_node("Feedback").text = ""
	hearing.get_node("VerdictReady").visible = false
	for index in _evidence_buttons.size():
		var evidence := current_case["evidence"][index] as Dictionary
		var button := _evidence_buttons[index]
		button.text = "%d  %s" % [index + 1, evidence["title"]]
		button.button_pressed = false
		button.disabled = false
	for index in _claim_buttons.size():
		var claim := current_case["claims"][index] as Dictionary
		var button := _claim_buttons[index]
		button.text = claim["text"]
		button.disabled = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_play_transition()
	_animate_character_entrance()


func _select_evidence(index: int) -> void:
	if index < 0 or index >= (current_case["evidence"] as Array).size():
		return
	var evidence := current_case["evidence"][index] as Dictionary
	selected_evidence_id = evidence["id"]
	for button_index in _evidence_buttons.size():
		_evidence_buttons[button_index].button_pressed = button_index == index
	ui.get_node("Hearing/EvidencePanel/Content/Detail").text = evidence["description"]
	ui.get_node("Hearing/Feedback").text = "已选「%s」；现在点击右侧矛盾证词。" % evidence["title"]
	_play_audio(audio_evidence)


func _challenge_claim(index: int) -> void:
	if selected_evidence_id.is_empty():
		ui.get_node("Hearing/Feedback").text = "先在左侧选择证据。"
		_pulse(ui.get_node("Hearing/EvidencePanel"))
		return
	var claim := current_case["claims"][index] as Dictionary
	var evidence := _find_by_id(current_case["evidence"], selected_evidence_id)
	var is_contradiction: bool = selected_evidence_id in claim["contradicted_by"]
	attempt_index += 1
	var fallback := NpcPerformanceEngine.authored_response(
		current_case,
		claim,
		evidence,
		is_contradiction,
		attempt_index,
	)
	_pending_fallback = fallback
	ai_gateway.request_performance(
		current_case["id"],
		current_case["npc"],
		"concede" if is_contradiction else "deflect",
		_allowed_facts_for_claim(claim),
		fallback,
	)
	if is_contradiction:
		if not exposed_claim_ids.has(claim["id"]):
			exposed_claim_ids.append(claim["id"])
		_claim_buttons[index].text = "已击穿 · %s" % claim["text"]
		_claim_buttons[index].disabled = true
		ui.get_node("Hearing/Feedback").text = "矛盾成立。证词已记入案卷。"
		_play_audio(audio_contradiction)
		_animate_character_pressure()
	else:
		ui.get_node("Hearing/Feedback").text = "这件证据与该证词不构成矛盾。"
		_pulse(_claim_buttons[index])
	selected_evidence_id = ""
	for button in _evidence_buttons:
		button.button_pressed = false
	_update_verdict_gate()


func _on_performance_ready(response: Dictionary) -> void:
	var accepted := response
	if not NpcPerformanceEngine.validate_response(current_case, response):
		accepted = _pending_fallback
	ui.get_node("Hearing/Subtitle/Content/NpcText").text = accepted["text"]


func _update_verdict_gate() -> void:
	var all_exposed := true
	for claim_id in current_case["required_claims"]:
		if not exposed_claim_ids.has(str(claim_id)):
			all_exposed = false
			break
	var button := ui.get_node("Hearing/VerdictReady") as Button
	button.visible = all_exposed
	if all_exposed:
		ui.get_node("Hearing/Instruction").text = "证据链成立。现在可以落印裁决。"
		_pulse(button)


func _show_verdict() -> void:
	_hide_all_screens()
	ui.get_node("VerdictScreen").visible = true
	selected_verdict.clear()
	for index in _verdict_buttons.size():
		var verdict := current_case["verdicts"][index] as Dictionary
		_verdict_buttons[index].text = "%s\n%s" % [verdict["title"], verdict["summary"]]
		_verdict_buttons[index].button_pressed = false
	ui.get_node("VerdictScreen/Content/ChoiceDetail").text = "先选择一项判词。"
	ui.get_node("VerdictScreen/Content/Confirm").visible = false
	get_tree().paused = true
	_play_transition()


func _select_verdict(index: int) -> void:
	selected_verdict = (current_case["verdicts"][index] as Dictionary).duplicate(true)
	for button_index in _verdict_buttons.size():
		_verdict_buttons[button_index].button_pressed = button_index == index
	var effects: Dictionary = selected_verdict["effects"]
	ui.get_node("VerdictScreen/Content/ChoiceDetail").text = (
		"%s\n%s" % [selected_verdict["summary"], _effect_text(effects)]
	)
	ui.get_node("VerdictScreen/Content/Confirm").visible = true


func _confirm_verdict() -> void:
	if selected_verdict.is_empty():
		return
	_play_audio(audio_seal)
	GameState.record_case_result(
		current_case["id"],
		selected_verdict,
		exposed_claim_ids,
		cases.size(),
	)
	_hide_all_screens()
	var result := ui.get_node("ResultScreen")
	result.visible = true
	result.get_node("Content/Title").text = selected_verdict["title"]
	result.get_node("Content/Body").text = selected_verdict["result"]
	result.get_node("Content/Reputation").text = _effect_text(selected_verdict["effects"])
	result.get_node("Content/Continue").text = (
		"查看终局" if current_case_index == cases.size() - 1 else "下一案"
	)
	_play_audio(audio_result)
	_play_transition()


func _continue_after_result() -> void:
	if current_case_index == cases.size() - 1:
		_show_ending()
	else:
		start_case(current_case_index + 1)


func _show_ending() -> void:
	_hide_all_screens()
	var ending := ui.get_node("EndingScreen")
	ending.visible = true
	var ending_id := GameState.ending_id()
	var endings := {
		"breaker": {
			"title": "破局者",
			"body": "你公开了案件入口与证据筛选规则。门派代表第一次在高堂上站起身，江湖令仍在，却不再只属于一个人。",
		},
		"iron": {
			"title": "铁血令主",
			"body": "你斩断了操盘者，却保留了他的棋盘。江湖恢复秩序，也学会在你的判印落下前保持沉默。",
		},
		"puppet": {
			"title": "执棋傀儡",
			"body": "你接管了证据网络。此后每场审理依旧庄严，只是所有答案都在升堂之前写好。",
		},
	}
	ending.get_node("Content/Title").text = endings[ending_id]["title"]
	ending.get_node("Content/Body").text = endings[ending_id]["body"]
	ending.get_node("Content/Stats").text = _reputation_text()
	get_tree().paused = true
	_play_transition()


func _show_case_select() -> void:
	_hide_all_screens()
	var screen := ui.get_node("CaseSelectScreen")
	screen.visible = true
	for index in cases.size():
		var button := screen.get_node("Content/Case%d" % (index + 1)) as Button
		var case_data := cases[index] as Dictionary
		button.text = "%s · %s" % [case_data["chapter"], case_data["title"]]
		button.disabled = index > GameState.unlocked_case
	get_tree().paused = true


func _show_settings() -> void:
	_hide_all_screens()
	var screen := ui.get_node("SettingsScreen")
	screen.visible = true
	screen.get_node("Panel/Content/Volume").value = float(GameState.settings["master_volume"])
	screen.get_node("Panel/Content/ReducedMotion").button_pressed = bool(
		GameState.settings["reduced_motion"]
	)
	screen.get_node("Panel/Content/LargeText").button_pressed = bool(
		GameState.settings["large_text"]
	)
	get_tree().paused = true


func _show_pause() -> void:
	ui.get_node("PauseScreen").visible = true
	get_tree().paused = true


func _resume() -> void:
	ui.get_node("PauseScreen").visible = false
	get_tree().paused = false


func _hide_all_screens() -> void:
	for screen_name in [
		"TitleScreen",
		"BriefScreen",
		"Hearing",
		"VerdictScreen",
		"ResultScreen",
		"EndingScreen",
		"CaseSelectScreen",
		"SettingsScreen",
		"PauseScreen",
	]:
		ui.get_node(screen_name).visible = false


func _configure_character() -> void:
	_hide_characters()
	var root_name := str(CHARACTER_BY_FACTION.get(current_case["faction"], ""))
	if root_name.is_empty() or not _character_roots.has(root_name):
		return
	var character := _character_roots[root_name] as Node3D
	character.visible = true
	character.position = Vector3(2.8, 0.0, 0.0)
	character.rotation = Vector3.ZERO
	character.scale = Vector3.ONE * 1.25


func _hide_characters() -> void:
	for character in _character_roots.values():
		(character as Node3D).visible = false


func _animate_character_entrance() -> void:
	var character := _visible_character()
	if character == null:
		return
	character.scale = Vector3.ONE * 0.96
	character.position.z = 0.35
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(character, "scale", Vector3.ONE, _motion_duration(0.5))
	tween.tween_property(character, "position:z", 0.0, _motion_duration(0.5))


func _animate_character_pressure() -> void:
	var character := _visible_character()
	if character == null:
		return
	var origin := character.position
	var tween := create_tween()
	tween.tween_property(character, "position:z", origin.z - 0.18, _motion_duration(0.12))
	tween.tween_property(character, "position:z", origin.z, _motion_duration(0.28))


func _visible_character() -> Node3D:
	for character in _character_roots.values():
		if (character as Node3D).visible:
			return character
	return null


func _pulse(control: Control) -> void:
	if bool(GameState.settings["reduced_motion"]):
		return
	var base := control.modulate
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(control, "modulate", Color(1.0, 0.48, 0.3, 1.0), 0.09)
	tween.tween_property(control, "modulate", base, 0.2)


func _play_transition() -> void:
	var transition := ui.get_node("Transition") as ColorRect
	transition.visible = true
	transition.modulate.a = 1.0
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(transition, "modulate:a", 0.0, _motion_duration(0.45))
	tween.tween_callback(func(): transition.visible = false)


func _motion_duration(duration: float) -> float:
	return 0.05 if bool(GameState.settings["reduced_motion"]) else duration


func _apply_accessibility() -> void:
	var extra := 4 if bool(GameState.settings["large_text"]) else 0
	for node in ui.find_children("*", "Label", true, false) + ui.find_children(
		"*", "Button", true, false
	):
		var control := node as Control
		if not control.has_meta("base_font_size"):
			control.set_meta("base_font_size", control.get_theme_font_size("font_size"))
		control.add_theme_font_size_override(
			"font_size",
			int(control.get_meta("base_font_size")) + extra,
		)


func _reputation_text() -> String:
	return "公信 %d  ·  威慑 %d  ·  仁德 %d  ·  腐化 %d" % [
		GameState.reputation["trust"],
		GameState.reputation["fear"],
		GameState.reputation["benevolence"],
		GameState.reputation["corruption"],
	]


func _effect_text(effects: Dictionary) -> String:
	return "公信 %+d  ·  威慑 %+d  ·  仁德 %+d  ·  腐化 %+d" % [
		effects.get("trust", 0),
		effects.get("fear", 0),
		effects.get("benevolence", 0),
		effects.get("corruption", 0),
	]


func _find_by_id(items: Array, target_id: String) -> Dictionary:
	for item_value in items:
		var item := item_value as Dictionary
		if str(item.get("id", "")) == target_id:
			return item
	return {}


func _allowed_facts_for_claim(claim: Dictionary) -> Array:
	var allowed: Array = []
	for fact_id in claim.get("fact_refs", []):
		allowed.append(fact_id)
	return allowed


func _play_audio(player: AudioStreamPlayer) -> void:
	if DisplayServer.get_name() != "headless":
		player.play()

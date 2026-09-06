class_name NpcPerformanceEngine
extends RefCounted


static func authored_response(
	case_data: Dictionary,
	claim: Dictionary,
	evidence: Dictionary,
	is_contradiction: bool,
	attempt_index: int,
) -> Dictionary:
	var candidates: Array = claim["success"] if is_contradiction else claim["failure"]
	var selected_index := posmod(
		hash(
			"%s:%s:%s:%d"
			% [case_data["id"], claim["id"], evidence["id"], attempt_index]
		),
		candidates.size(),
	)
	var fact_refs: Array = []
	if is_contradiction:
		fact_refs.assign(claim.get("fact_refs", []))
	return {
		"text": str(candidates[selected_index]),
		"fact_refs": fact_refs,
		"emotion": "pressured" if is_contradiction else "controlled",
		"action": "step_back" if is_contradiction else "hold_gaze",
		"source": "authored_fallback",
	}


static func validate_response(case_data: Dictionary, response: Dictionary) -> bool:
	if str(response.get("text", "")).strip_edges().is_empty():
		return false
	var allowed_fact_ids := {}
	for fact_value in case_data.get("facts", []):
		var fact := fact_value as Dictionary
		allowed_fact_ids[str(fact["id"])] = true
	for fact_id in response.get("fact_refs", []):
		if not allowed_fact_ids.has(str(fact_id)):
			return false
	return str(response.get("emotion", "")) in [
		"calm",
		"angry",
		"fearful",
		"sly",
		"grief",
		"proud",
		"pressured",
		"controlled",
	]

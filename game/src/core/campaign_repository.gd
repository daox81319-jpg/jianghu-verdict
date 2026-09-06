class_name CampaignRepository
extends RefCounted

const CAMPAIGN_PATH := "res://data/cases/campaign.json"
const EXPECTED_SCHEMA_VERSION := 1


static func load_campaign() -> Dictionary:
	var file := FileAccess.open(CAMPAIGN_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to open campaign data")
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_error("Campaign data is not a JSON object")
		return {}
	var campaign := parsed as Dictionary
	var errors := validate_campaign(campaign)
	if not errors.is_empty():
		for error in errors:
			push_error(error)
		return {}
	return campaign


static func validate_campaign(campaign: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	if int(campaign.get("schema_version", -1)) != EXPECTED_SCHEMA_VERSION:
		errors.append("Unsupported campaign schema version")
	var cases: Array = campaign.get("cases", [])
	if cases.size() != 4:
		errors.append("V1 campaign must contain exactly four cases")
	var case_ids := {}
	for case_value in cases:
		if not case_value is Dictionary:
			errors.append("Case entry is not an object")
			continue
		var case_data := case_value as Dictionary
		var case_id := str(case_data.get("id", ""))
		if case_id.is_empty() or case_ids.has(case_id):
			errors.append("Case id is empty or duplicated: %s" % case_id)
		case_ids[case_id] = true
		errors.append_array(_validate_case(case_data))
	return errors


static func _validate_case(case_data: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var case_id := str(case_data.get("id", "<unknown>"))
	var fact_ids := {}
	var claim_ids := {}
	var evidence_ids := {}

	for fact_value in case_data.get("facts", []):
		var fact := fact_value as Dictionary
		fact_ids[str(fact.get("id", ""))] = true
	for claim_value in case_data.get("claims", []):
		var claim := claim_value as Dictionary
		var claim_id := str(claim.get("id", ""))
		claim_ids[claim_id] = true
		for fact_id in claim.get("fact_refs", []):
			if not fact_ids.has(str(fact_id)):
				errors.append("%s claim %s references unknown fact %s" % [case_id, claim_id, fact_id])
	for evidence_value in case_data.get("evidence", []):
		var evidence := evidence_value as Dictionary
		var evidence_id := str(evidence.get("id", ""))
		evidence_ids[evidence_id] = true
		for fact_id in evidence.get("fact_refs", []):
			if not fact_ids.has(str(fact_id)):
				errors.append(
					"%s evidence %s references unknown fact %s"
					% [case_id, evidence_id, fact_id]
				)

	for claim_value in case_data.get("claims", []):
		var claim := claim_value as Dictionary
		for evidence_id in claim.get("contradicted_by", []):
			if not evidence_ids.has(str(evidence_id)):
				errors.append(
					"%s claim %s references unknown evidence %s"
					% [case_id, claim.get("id", ""), evidence_id]
				)
	for required_id in case_data.get("required_claims", []):
		if not claim_ids.has(str(required_id)):
			errors.append("%s requires unknown claim %s" % [case_id, required_id])
	if (case_data.get("verdicts", []) as Array).size() != 3:
		errors.append("%s must contain exactly three verdicts" % case_id)
	return errors

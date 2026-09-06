extends SceneTree


func _initialize() -> void:
	var campaign := CampaignRepository.load_campaign()
	assert(not campaign.is_empty())
	assert((campaign["cases"] as Array).size() == 4)
	assert(CampaignRepository.validate_campaign(campaign).is_empty())

	var response_count := 0
	for case_value in campaign["cases"]:
		var case_data := case_value as Dictionary
		var evidence_ids := {}
		for evidence_value in case_data["evidence"]:
			var evidence := evidence_value as Dictionary
			evidence_ids[evidence["id"]] = evidence
		for claim_value in case_data["claims"]:
			var claim := claim_value as Dictionary
			assert(not (claim["contradicted_by"] as Array).is_empty())
			for evidence_id in claim["contradicted_by"]:
				assert(evidence_ids.has(evidence_id))
				var response := NpcPerformanceEngine.authored_response(
					case_data,
					claim,
					evidence_ids[evidence_id],
					true,
					0,
				)
				assert(NpcPerformanceEngine.validate_response(case_data, response))
				response_count += 1

	var invalid := {
		"text": "伪造事实",
		"fact_refs": ["UNKNOWN_FACT"],
		"emotion": "calm",
	}
	assert(
		not NpcPerformanceEngine.validate_response(
			(campaign["cases"] as Array)[0],
			invalid,
		)
	)
	print(JSON.stringify({
		"cases": (campaign["cases"] as Array).size(),
		"validated_responses": response_count,
		"unknown_fact_rejected": true,
	}))
	quit(0)

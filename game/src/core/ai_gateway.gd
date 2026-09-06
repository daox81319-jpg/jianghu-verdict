class_name AiGateway
extends Node

signal performance_ready(response: Dictionary)

const ENDPOINT_ENV := "JIANGHU_AI_ENDPOINT"
const TIMEOUT_SECONDS := 2.2

var _fallback: Dictionary = {}
var _request: HTTPRequest


func _ready() -> void:
	_request = HTTPRequest.new()
	_request.timeout = TIMEOUT_SECONDS
	_request.request_completed.connect(_on_request_completed)
	add_child(_request)


func request_performance(
	case_id: String,
	npc_name: String,
	speech_act: String,
	allowed_facts: Array,
	fallback: Dictionary,
) -> void:
	_fallback = fallback
	var endpoint := OS.get_environment(ENDPOINT_ENV).strip_edges()
	if endpoint.is_empty():
		performance_ready.emit(fallback)
		return
	if _request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		_request.cancel_request()
	var payload := {
		"case_id": case_id,
		"npc": npc_name,
		"speech_act": speech_act,
		"allowed_facts": allowed_facts,
		"output_contract": {
			"text": "string",
			"fact_refs": "string[]",
			"emotion": "enum",
			"action": "enum",
		},
	}
	var error := _request.request(
		endpoint,
		PackedStringArray(["Content-Type: application/json"]),
		HTTPClient.METHOD_POST,
		JSON.stringify(payload),
	)
	if error != OK:
		performance_ready.emit(fallback)


func _on_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		performance_ready.emit(_fallback)
		return
	var parsed: Variant = JSON.parse_string(body.get_string_from_utf8())
	if not parsed is Dictionary:
		performance_ready.emit(_fallback)
		return
	var response := parsed as Dictionary
	response["source"] = "remote"
	performance_ready.emit(response)

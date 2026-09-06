extends SceneTree


func _initialize() -> void:
	var packed := load("res://assets/models/judgment_hall.glb") as PackedScene
	assert(packed != null)
	var root := packed.instantiate()
	var names: Array[String] = []
	var counts := {"mesh_count": 0, "triangle_count": 0}
	_visit(root, names, counts)

	for required_name in [
		"JV_CH_BladeEnvoy",
		"JV_CH_PoisonEnvoy",
		"JV_CH_MonkEnvoy",
		"JV_CH_Mastermind",
		"MARKER_NPC",
		"MARKER_DESK",
		"MARKER_SEAL",
		"JV_PROP_JudgmentSeal",
	]:
		assert(names.has(required_name))
	assert(counts["mesh_count"] >= 40)
	assert(counts["triangle_count"] < 120_000)
	print(JSON.stringify({
		"mesh_count": counts["mesh_count"],
		"triangle_count": counts["triangle_count"],
		"required_nodes": 8,
	}))
	root.free()
	packed = null
	call_deferred("_finish")


func _visit(
	node: Node,
	names: Array[String],
	counts: Dictionary,
) -> void:
	names.append(node.name)
	if node is MeshInstance3D:
		counts["mesh_count"] += 1
		var mesh := (node as MeshInstance3D).mesh
		if mesh:
			counts["triangle_count"] += mesh.get_faces().size() / 3
	for child in node.get_children():
		_visit(child, names, counts)


func _finish() -> void:
	await process_frame
	quit(0)

extends Viewport

onready var mesh = $MeshInstance.mesh

func generate(element):
	randomize()
	$AnimationPlayer.play("roate")
	var surf = MeshDataTool.new()
	surf.create_from_surface(mesh, 0)

	for _j in range(200):
		var dir = Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)).normalized()

		for i in range(surf.get_vertex_count()):
			var v = surf.get_vertex(i)
			var normal = surf.get_vertex_normal(i)

			var dot = normal.normalized().dot(dir)
			var sharpness = 50
			dot = exp(dot*sharpness) / (exp(dot*sharpness) + 1) - 0.5

			v += dot * normal * 0.01

			surf.set_vertex(i, v)

		for i in range(surf.get_vertex_count()):
			var v = surf.get_vertex(i)
			var dist = v.length() 
			var dist_normalized = range_lerp(dist, 0.9, 1.1, 0, 1) # bring dist to 0..1 range
		
			var uv = Vector2(dist_normalized, 0)
			surf.set_vertex_uv(i, uv)

	var f = File.new()
	f.open("res://assets/planet_stuff/pallete_map.json", File.READ)
	var palletes = parse_json(f.get_as_text())[element]
	f.close()
	
	var whichFile = randi()%len(palletes)
	var mmesh = ArrayMesh.new()
	surf.commit_to_surface(mmesh)
	mmesh.surface_set_material(0, preload("res://assets/planet_stuff/Planet.tres"))
	mmesh.surface_get_material(0).albedo_texture = load(palletes[whichFile])
	$MeshInstance.mesh = mmesh


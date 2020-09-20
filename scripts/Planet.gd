extends Viewport

onready var mesh = $MeshInstance.mesh

func generate():
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

	for i in range(surf.get_face_count()):	
		var v1i = surf.get_face_vertex(i,0)
		var v2i = surf.get_face_vertex(i,1)
		var v3i = surf.get_face_vertex(i,2)
		
		var v1 = surf.get_vertex(v1i)
		var v2 = surf.get_vertex(v2i)
		var v3 = surf.get_vertex(v3i)
		
		var u = v2 - v1
		var v = v3 - v1
		var normal = Vector3(
			u.y * v.z - u.z * v.y,
			u.z * v.x - u.x * v.z,
			u.x * v.z - u.z * v.x
		).normalized()
		
		surf.set_vertex_normal(v1i, normal)
		surf.set_vertex_normal(v2i, normal)
		surf.set_vertex_normal(v3i, normal)

	var files = []
	var dir = Directory.new()
	var path = "res://assets/planet_stuff/planetpallets" 
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break

		if file.ends_with("png"):
			files.append(file)

	
	var pallete = rand_range(0, len(files) - 1)
	var mmesh = ArrayMesh.new()
	surf.commit_to_surface(mmesh)
	mmesh.surface_set_material(0, preload("res://assets/planet_stuff/Planet.tres"))
	mmesh.surface_get_material(0).albedo_texture = load(path + "/" + files[pallete])
	$MeshInstance.mesh = mmesh


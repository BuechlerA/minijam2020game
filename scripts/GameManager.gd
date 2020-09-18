extends Control
export (String, FILE, "*.json") var path : String
var library = {}


func load_json_file(PATH) -> Dictionary:
	var file = File.new()
	if file.file_exists(PATH):
		file.open(PATH, file.READ)
		var data = parse_json(file.get_as_text())
		return data
	else:
		return {}


func _ready():
	print(library)
	
func _create_planet():
	pass
	
func _create_alien():
	pass


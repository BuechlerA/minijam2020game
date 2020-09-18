extends Control
export (String, FILE, "*.json") var path : String
var library = {}
const BODY_PARTS = ["BODY","CHEST", "ARM","EYE","MOUTH","NOSE","HAIR", "EAR"]
const ELEMENTALS = ["FIRE","WATER","POISON","ICE","HUMAN"]

onready var avatarObject = $PhonePanel/VBoxContainer/AVATAR

func load_json_file(PATH) -> Dictionary:
	var file = File.new()
	if file.file_exists(PATH):
		file.open(PATH, file.READ)
		var data = parse_json(file.get_as_text())
		return data
	else:
		return {}

func _ready():
	library = load_json_file(path)
	_create_alien()
	_create_planet()
	
func _create_planet():
	pass
	
func _create_alien():
	var appearance = []
	for index in range(BODY_PARTS.size()):
		randomize()
		var part = BODY_PARTS[index]
		var element = ELEMENTALS[randi()%ELEMENTALS.size()]
		appearance.append(library.get(element, "null").get(part, "null"))
	avatarObject.SET_APPEARANCE(appearance)

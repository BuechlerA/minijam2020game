extends Control
export (String, FILE, "*.json") var path : String

var library = {}
const BODY_PARTS = ["BODY","CHEST", "ARM","EYE","MOUTH","NOSE","HAIR", "EAR"]
const ELEMENTALS = ["FIRE","WATER","POISON","ICE","HUMAN"]

var avatarObject
var phone
var phone_tween

const phone_vec_out = Vector2(0.0,264.34)
const phone_vec_in = Vector2(0.0,0.0)

func phone_mover(IN=true, DURATION=1.0):
	if IN == true:
		phone_tween.interpolate_property(phone, "rect_position", phone.rect_position, phone_vec_in, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	else:
		phone_tween.interpolate_property(phone, "rect_position", phone.rect_position, phone_vec_out, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	phone_tween.start()

func _ready():
	phone=  $PhoneAnimator/PhonePanel
	phone_tween = Tween.new()
	phone.add_child(phone_tween)
	
	avatarObject = phone.get_node("VBoxContainer/AVATAR")
	phone.connect("CONFIRM",self,"_on_confirmed")
	
	library = load_json_file(path)
	_create_alien()
	_create_planet()
	
	yield(get_tree().create_timer(2.0),"timeout")
	phone_mover(true,1.15)
func load_json_file(PATH) -> Dictionary:
	var file = File.new()
	if file.file_exists(PATH):
		file.open(PATH, file.READ)
		var data = parse_json(file.get_as_text())
		return data
	else:
		return {}

func _on_confirmed(value):
	if value == false: #no
		_create_alien()
		print("DONT LIKE THIS GUY")
	else:
		print("LIKE THIS GUY!!!")

func _create_planet():
	$Window.generate_new_planet()
	
func _create_alien():
	var appearance = []
	for index in range(BODY_PARTS.size()):
		randomize()
		var part = BODY_PARTS[index]
		var element = ELEMENTALS[randi()%ELEMENTALS.size()]
		appearance.append(library.get(element, "null").get(part, "null"))
	avatarObject.SET_APPEARANCE(appearance)

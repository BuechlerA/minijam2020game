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

#genetic thingies
var currPlayerAppearance = []
var currPartnerAppearance = [] #current alien traits
var acceptedDates = [] #array of accepted aliens
var generationCount #counts generations
var choiceCount = 0 
var choiceLimit = 1 #change for difficulty level maybe?

func phone_mover(IN=true, DURATION=1.0):
	if IN == true:
		phone_tween.interpolate_property(phone, "rect_position", phone.rect_position, phone_vec_in, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	else:
		phone_tween.interpolate_property(phone, "rect_position", phone.rect_position, phone_vec_out, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	phone_tween.start()

func _ready():
	phone =  $PhoneAnimator/PhonePanel
	phone_tween = Tween.new()
	phone.add_child(phone_tween)
	
	avatarObject = phone.get_node("VBoxContainer/AVATAR")
	phone.connect("CONFIRM",self,"_on_confirmed")
	phone.connect("SHOWSELF", self,"_show_self")
	
	library = load_json_file(path)
	
	#this loop creates the player character with human element parts only
	for i in range(BODY_PARTS.size()):
		var bodypart = BODY_PARTS[i]
		var element = ELEMENTALS[4]
		currPlayerAppearance.append(library.get(element, "null").get(bodypart, "null"))
	print(currPlayerAppearance)
	
	#create alien and planet to begin wiht something
	_create_alien()
	_create_planet()
	
	#slide the phone screen into the scene
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
	elif value == true:
		if choiceCount <= choiceLimit:
			print("LIKE THIS GUY!!!")
			acceptedDates.append(currPartnerAppearance)
			print("accepted people: ", acceptedDates)
			choiceCount += 1
			_create_alien()
		else:
			#choice limit reached
			print("choice limit")
			#now generate the offspring
			_generateOffspring()
			pass
	
func _show_self(showself = false):
	if showself == true:
		avatarObject.SET_APPEARANCE(currPlayerAppearance)
	else:
		avatarObject.SET_APPEARANCE(currPartnerAppearance)

func _create_planet():
	$PlanetImage.texture = ($Planet as Viewport).get_texture()
	
func _create_alien():
	currPartnerAppearance.clear()
	randomize()
	for index in range(BODY_PARTS.size()):
		var part = BODY_PARTS[index]
		var element = ELEMENTALS[randi()%ELEMENTALS.size()]
		currPartnerAppearance.append(library.get(element, "null").get(part, "null"))
	avatarObject.SET_APPEARANCE(currPartnerAppearance)
	
func _generateOffspring():
	var nextOffspring
	
func _scoreGeneration():
	pass

extends Control
export (String, FILE, "*.json") var partlibpath : String
export (String, FILE, "*.json") var domlibpath : String
export (String, FILE, "*.json") var planetlibpath : String

var library = {}
var dominanceChart = {}
var planetlib = {}

const BODY_PARTS = ["BODY","CHEST", "ARM","EYE","MOUTH","NOSE","HAIR", "EAR"]
const ELEMENTALS = ["FIRE","WATER","POISON","ICE","HUMAN"]

var avatarObject
var phone
var phone_tween

const phone_vec_out = Vector2(0.0,264.34)
const phone_vec_in = Vector2(0.0,0.0)

#genetic thingies
var currPlayerAppearance = []
var playerTraitDominance = []
var currPartnerAppearance = [] #current alien traits
var acceptedDates = [] #array of accepted aliens
var generationCount #counts generations
var choiceCount = 0 
var choiceLimit = 1 #change for difficulty level maybe?

#planetary traits
const PLANET_PARTS = ["OCEAN","CONTINENT","ATMOSPHERE"]
const PLANET_ELEMENTALS = ["FIRE","WATER","POISON","ICE","HUMAN"]
var currPlanetAppearance = []

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
	
	library = load_json_file(partlibpath)
	dominanceChart = load_json_file(domlibpath)
	planetlib = load_json_file(planetlibpath)
	
	_create_player()
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
		#print("DONT LIKE THIS GUY")
	elif value == true:
		if choiceCount <= choiceLimit:
			#print("LIKE THIS GUY!!!")
			acceptedDates.append(currPartnerAppearance)
			#print("accepted people: ", acceptedDates)
#			choiceCount += 1
#			if choiceCount >= choiceLimit:
			_generateOffspring()
#			else:
			_create_alien()
	
func _show_self(showself = false):
	if showself == true:
		avatarObject.SET_APPEARANCE(currPlayerAppearance)
	else:
		avatarObject.SET_APPEARANCE(currPartnerAppearance)

func _create_player():
	#this loop creates the player character with human element parts only
	for i in range(BODY_PARTS.size()):
		var bodypart = BODY_PARTS[i]
		var element = ELEMENTALS[4]
		currPlayerAppearance.append(library.get(element, "null").get(bodypart, "null"))
	#print(currPlayerAppearance)

func _create_planet():
	$Window.generate_new_planet()
	currPlanetAppearance.clear()
	for i in range(PLANET_PARTS.size()):
		var part = PLANET_PARTS[i]
		var element = PLANET_ELEMENTALS[randi() % PLANET_ELEMENTALS.size()]
		print(part,": ",element)
		currPlanetAppearance.append(planetlib.get(element).get(part))
	print(currPlanetAppearance)

func _create_alien():
	currPartnerAppearance.clear()
	randomize()
	for index in range(BODY_PARTS.size()):
		var part = BODY_PARTS[index]
		var element = ELEMENTALS[randi()%ELEMENTALS.size()]
		currPartnerAppearance.append(library.get(element, "null").get(part, "null"))
	avatarObject.SET_APPEARANCE(currPartnerAppearance)
	
func _generateOffspring():
	var nextOffspring = currPlayerAppearance
	var randIndex = randi() % BODY_PARTS.size()
	#part is randomly chosen for now, need to implement to propability chart
	var randomPart = [randIndex, currPartnerAppearance[randIndex]]
	print("you got a new ",BODY_PARTS[randIndex])
	#list the chosen traits and calculate dominance with the amount the trait was chosen
	playerTraitDominance.append(randomPart[1])
	#print("trait dominance:", playerTraitDominance)
#	for i in range(ELEMENTALS.size()):
#		for j in range(BODY_PARTS.size()):
#			#print the count of total collected traits in console for debug
#			print(ELEMENTALS[i]," ",BODY_PARTS[j],": ",playerTraitDominance.count(library.get(ELEMENTALS[i],"null").get(BODY_PARTS[j],"null")))
	
#	#apply the next trait on the player
#	for o in range(ELEMENTALS.size()):
#		for k in range(BODY_PARTS.size()):
#			print(dominanceChart.get(ELEMENTALS[o]).get(BODY_PARTS[k]))
	nextOffspring[randomPart[0]] = randomPart[1]
#	print("my new self: ",nextOffspring)
	
func _scoreGeneration():
	var score
	
	print("current fitness for planet: ", score)
	pass

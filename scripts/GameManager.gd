extends Control
export (String, FILE, "*.json") var libpath : String
export (String, FILE, "*.json") var planetpath : String
export (String, FILE, "*.json") var dominancepath : String

enum {
	RESTART,
	CHOOSE,
	RESULT,
	PARTNER_DISPLAY,
	PARTNER_COMBINE,
	RESET
}

var currentState = RESTART

var bodypart_library = {}
var trait_dominance = {}
var planet_traits = {}
const BODY_PARTS = ["BODY","CHEST", "ARM","EYE","MOUTH","NOSE","HAIR", "EAR"]
const PLANET_PARTS = ["OCEAN", "CONTINENTS", "ATMOSPHERE"]
const ELEMENTALS = ["FIRE","WATER","POISON","ICE","HUMAN"]

var avatarObject
var phone
var phone_tween

const phone_vec_out = Vector2(0.0,264.34)
const phone_vec_in = Vector2(0.0,0.0)

#planet attributes
var currPlanetAppearance = []

#genetic thingies
var currPlayerAppearance = []
var currPartnerAppearance = [] #current alien traits

var acceptedDates = [] #array of accepted aliens
var generationCount = 0 #counts generations

var choiceCount = 0 
var choiceLimit = 12 #change for difficulty level maybe?

const messages = [
"I like you",
"I love you",
"Let´s do something",
"Be cute!",
"Stay still"
]

var time_stamp = 0.0
func phone_mover(IN=true, DURATION=1.0):
	if IN == true:
		phone_tween.interpolate_property(phone, "rect_position", phone.rect_position, phone_vec_in, DURATION, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.0)
	else:
		phone_tween.interpolate_property(phone, "rect_position", phone.rect_position, phone_vec_out, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	phone_tween.start()

func _ready():
	time_stamp = OS.get_ticks_msec()
	phone =  $PhoneAnimator/PhonePanel
	phone_tween = Tween.new()
	phone.add_child(phone_tween)
	
	avatarObject = phone.get_node("AVATAR")
	phone.connect("CONFIRM",self,"_on_confirmed")
	phone.connect("SHOWSELF", self,"_show_self")
	
	#assign the loaded json files to dictionaries
	bodypart_library = load_json_file(libpath)
	planet_traits = load_json_file(planetpath)
	trait_dominance = load_json_file(dominancepath)
	
	#create alien and planet to begin wiht something
	avatarObject.hide()
	_create_startcharacter()
	_create_alien()
	_create_planet()
	avatarObject.show()
	
	#initate states
	currentState = CHOOSE
	
	#slide the phone screen into the scene
	yield(get_tree().create_timer(2.0),"timeout")
	phone_mover(true,0.75)
	
func load_json_file(PATH) -> Dictionary:
	var file = File.new()
	if file.file_exists(PATH):
		file.open(PATH, file.READ)
		var data = parse_json(file.get_as_text())
		return data
	else:
		return {}

func _on_confirmed(value):
	if currentState == CHOOSE:
		if value == false: #no
			_create_alien()
			print("SKIP, NEXT PLEASE")
		elif value == true:
			if choiceCount < choiceLimit:
				print("LIKE THIS GUY!!!")
				acceptedDates.append(currPartnerAppearance)
				phone.add_selected_guy( currPartnerAppearance )
				choiceCount += 1
				_create_alien()
			else:
				#choice limit reached
				print("reached choice limit")
				print("accepted people: ", acceptedDates)
				phone.BUTTON_VISIBLE("NO",false)
				currentState = RESULT
				
	elif currentState == RESULT: #any button press
		currentState = PARTNER_DISPLAY
		
	elif currentState == PARTNER_DISPLAY:
		randomize()
		_only_one_wins()
		phone.SET_MESSAGE( "Adam :" + messages[randi()%messages.size()]  )
		_generateOffspring()
		currentState = PARTNER_COMBINE
		
	elif currentState == PARTNER_COMBINE:
		#run evolution animation
		#if animation ended, currentState to RESET
		phone.SET_MESSAGE( "This is your new baby")
		#set main avatar to baby

func _show_self(showself = false):
	if currentState != PARTNER_COMBINE:
		if showself == true:
			avatarObject.SET_APPEARANCE(currPlayerAppearance)
		else:
			avatarObject.SET_APPEARANCE(currPartnerAppearance)

func _create_planet():
	var planet_colors = []
	for i in range(PLANET_PARTS.size()):
		var element = ELEMENTALS[randi()%ELEMENTALS.size()]
		print(PLANET_PARTS[i], element)
		planet_colors.append(planet_traits.get(element, "null").get(PLANET_PARTS[i], "null"))
	print(planet_colors)
	$Window.generate_new_planet()
	
func _create_startcharacter():
	#this loop creates the player character with human element parts only
	#ignore this operation as a character has been already created
	for i in range(BODY_PARTS.size()):
		var bodypart = BODY_PARTS[i]
		var element = ELEMENTALS[4]
		currPlayerAppearance.append(bodypart_library.get(element, "null").get(bodypart, "null"))
	print(currPlayerAppearance)
	
func _create_alien():
	currPartnerAppearance.clear()
	randomize()
	for index in range(BODY_PARTS.size()):
		var part = BODY_PARTS[index]
		var element = ELEMENTALS[randi()%ELEMENTALS.size()]
		currPartnerAppearance.append(bodypart_library.get(element, "null").get(part, "null"))
	avatarObject.SET_APPEARANCE(currPartnerAppearance)
	
func _only_one_wins():
	var lucky_index = randi()%acceptedDates.size()
	currPartnerAppearance = acceptedDates[lucky_index]
	currentState = PARTNER_DISPLAY
func _show_match():
	avatarObject.SET_APPEARANCE(currPartnerAppearance)
	print("your match: ", currPartnerAppearance)
	
func _generateOffspring():
	for i in range(BODY_PARTS.size()): #body parts in order
		var my_part = currPlayerAppearance[i]
		var her_part = currPartnerAppearance[i]
		
		#get success rate, compare
		#pick between her part vs my_part
	pass

func _evolution_animation_fancy():
		var time = (OS.get_ticks_msec() - time_stamp) /1000.0
		if time > 0.15:
			var evo_look = []
			randomize()
			var part = ""
			for i in range(BODY_PARTS.size()):
				var switch = randi() & 1
				if switch == 0:	part= currPlayerAppearance[i]
				else:			part= currPartnerAppearance[i]
				evo_look.append(part)
			avatarObject.SET_APPEARANCE(evo_look)
			time_stamp = OS.get_ticks_msec()

func _process(delta):
	match currentState:
		RESTART:
			_create_startcharacter()
			_create_alien()
			_create_planet()
			avatarObject.show()
			currentState = CHOOSE
		CHOOSE:
			#let player choose things here, this state calculates nothing
			pass
		RESULT:
			#show text: You like xxx people
			pass
		PARTNER_DISPLAY:
			#this guy likes you
			_show_match()
			pass
		PARTNER_COMBINE:
			#sexy time
			#blink avatars!!!!!!!!
			_evolution_animation_fancy()
			pass
		RESET:
			#this is your baby aka your new player
			#congratulations
			pass

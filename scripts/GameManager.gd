extends Control
export (String, FILE, "*.json") var partlibpath : String
export (String, FILE, "*.json") var domlibpath : String
export (String, FILE, "*.json") var planetlibpath : String

enum {
	RESTART,
	CHOOSE,
	RESULT,
	PARTNER_DISPLAY,
	PARTNER_COMBINE,
	RESET
}

var st = RESTART

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
	
	library = load_json_file(path)
	
	#create alien and planet to begin wiht something
	avatarObject.hide()

	_create_startcharacter()
	_create_alien()
	_create_planet()
	avatarObject.show()
	st = CHOOSE
	
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
	if st == CHOOSE:
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
				st = RESULT
				
	elif st == RESULT: #any button press
		st = PARTNER_DISPLAY
		
	elif st == PARTNER_DISPLAY:
		randomize()
		_only_one_wins()
		phone.SET_MESSAGE( "Adam :" + messages[randi()%messages.size()]  )
		_generateOffspring()
		st = PARTNER_COMBINE
		
	elif st == PARTNER_COMBINE:
		#run evolution animation
		#if animation ended, st to RESET
		phone.SET_MESSAGE( "This is your new baby")

		#set main avatar to baby

func _show_self(showself = false):
	if st != PARTNER_COMBINE:
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
	
func _create_startcharacter():
	#this loop creates the player character with human element parts only
	#ignore this operation as a character has been already created
	for i in range(BODY_PARTS.size()):
		var bodypart = BODY_PARTS[i]
		var element = ELEMENTALS[4]
		currPlayerAppearance.append(library.get(element, "null").get(bodypart, "null"))
	print(currPlayerAppearance)
	
func _create_alien():
	currPartnerAppearance.clear()
	randomize()
	for index in range(BODY_PARTS.size()):
		var part = BODY_PARTS[index]
		var element = ELEMENTALS[randi()%ELEMENTALS.size()]
		currPartnerAppearance.append(library.get(element, "null").get(part, "null"))
	avatarObject.SET_APPEARANCE(currPartnerAppearance)
	
func _only_one_wins():
	var lucky_index = randi()%acceptedDates.size()
	currPartnerAppearance = acceptedDates[lucky_index]
	st = PARTNER_DISPLAY
	
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
	match st:
		RESTART:
			_create_startcharacter()
			_create_alien()
			_create_planet()
			avatarObject.show()
			st = CHOOSE
		CHOOSE:
			#let player choose things here, this state calculates nothing
			pass
		RESULT:
			#show text: You like xxx people
			pass
		PARTNER_DISPLAY:
			#this guy likes you
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

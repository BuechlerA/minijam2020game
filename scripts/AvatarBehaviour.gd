extends Control



const lib_path = "res://assets/"
const lib_items ={}
const part_order = ["SP_Body",
					"SP_Chest",
					"SP_Arm",
					"SP_Eye",
					"SP_Mouth",
					"SP_Nose",
					"SP_Hair",
					"SP_Ear"]

func GET_FILE(FILE):
	var path2file = lib_path + FILE
	return load(path2file)

func SET_PART(OBJ, BODY_PART):
	var f = GET_FILE(BODY_PART)
	if f:OBJ.set_texture(f)
	else:OBJ.hide()

func SET_APPEARANCE(DATA):
	#print("Avatar/SET_APPEARANCE ", DATA)
	#DATA SHOULD CONTAIN 7 values for a new body
	#DATA will be created using a dictionary
	#The dictionary has to be json
	#we can convert the google sheet into a json using python
	for index in range(part_order.size()):
		SET_PART( get_node(part_order[index]), DATA[index])

func _ready():
	pass

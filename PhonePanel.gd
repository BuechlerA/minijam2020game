extends Control

signal CONFIRM(YN)
signal SHOWSELF(TF)

const ava = preload("res://instances/AVATAR.tscn")
onready var ava_text = $VBoxContainer/Control/Text
onready var selected_guys = $VBoxContainer/Control/SelectedList
func _ready():

	ava_text.hide()
	$Buttons/NO.connect("pressed", self, "_BUTTON_NO")
	$Buttons/YES.connect("pressed", self, "_BUTTON_YES")
	
	$VBoxContainer/ShowSelf.connect("button_down", self, "_BUTTON_SHOW")
	$VBoxContainer/ShowSelf.connect("button_up", self, "_BUTTON_HIDE")

func add_selected_guy(data):
	var new_ava= ava.instance()
	new_ava.SET_APPEARANCE(data)
	selected_guys.add_child(new_ava)
func _BUTTON_NO():
	emit_signal("CONFIRM",false)
	#print("NO")
func _BUTTON_YES():
	emit_signal("CONFIRM",true)
	#print("YES")
func _BUTTON_SHOW():
	emit_signal("SHOWSELF", true)
	#print("SHOW")
func _BUTTON_HIDE():
	emit_signal("SHOWSELF", false)
	#print("HIDE")

func BUTTON_VISIBLE(NAME,value):
	$Buttons.get_node(NAME).visible = value
	#print("HIDE")
	
func SET_MESSAGE(msg):
	ava_text.show()
	selected_guys.hide()
	ava_text.set_text(msg)

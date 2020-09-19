extends Control

signal CONFIRM(YN)
signal SHOWSELF(TF)

func _ready():
	$Buttons/NO.connect("pressed", self, "_BUTTON_NO")
	$Buttons/YES.connect("pressed", self, "_BUTTON_YES")
	$VBoxContainer/ShowSelf.connect("button_down", self, "_BUTTON_SHOW")
	$VBoxContainer/ShowSelf.connect("button_up", self, "_BUTTON_HIDE")

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


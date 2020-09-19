extends Control

signal CONFIRM(YN)

func _ready():
	$Buttons/NO.connect("pressed", self, "_BUTTON_NO")
	$Buttons/YES.connect("pressed", self, "_BUTTON_YES")

func _BUTTON_NO():
	emit_signal("CONFIRM",false)
	print("NO")
func _BUTTON_YES():
	emit_signal("CONFIRM",true)
	print("YES")

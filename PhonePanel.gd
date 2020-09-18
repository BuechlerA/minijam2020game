extends Control


func _ready():
	$Buttons/ButtonNo.connect("buttonPressed", self, "OnButtonPressed")
	$Buttons/ButtonYes.connect("buttonPressed", self, "OnButtonPressed")

func OnButtonPressed(type):
	print(type)

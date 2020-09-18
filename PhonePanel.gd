extends Control


func _ready():
	$VBoxContainer/Buttons/ButtonNo.connect("buttonPressed", self, "OnButtonPressed")
	$VBoxContainer/Buttons/ButtonYes.connect("buttonPressed", self, "OnButtonPressed")

func OnButtonPressed(type):
	print(type)

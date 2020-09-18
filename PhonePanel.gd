extends Control


func _ready():
	$VBoxContainer/HBoxContainer/ButtonNo.connect("buttonPressed", self, "OnButtonPressed")
	$VBoxContainer/HBoxContainer/ButtonYes.connect("buttonPressed", self, "OnButtonPressed")

func OnButtonPressed(type):
	print(type)

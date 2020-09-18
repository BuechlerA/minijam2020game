extends Button
enum BUTTON_TYPE {YES, NO}
export(BUTTON_TYPE) var type

signal buttonPressed(type)

func _ready():
	self.connect("button_pressed", self, "OnButtonPressed")

func OnButtonPressed():
	emit_signal("buttonPressed", type)

extends Button
enum BUTTON_TYPE {YES, NO}
export(BUTTON_TYPE) var type

signal buttonPressed(type)

func _ready():
	self.connect("button_up", self, "OnButtonPressed")

func OnButtonPressed():
	emit_signal("buttonPressed", type)

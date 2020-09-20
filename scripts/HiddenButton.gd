extends TextureButton

onready var label = $Label
const duration = 0.5
func _ready():
	self.connect("button_down",self,	"_on_pressed")
	self.connect("button_up",self,		"_on_released")
	
	label.hide()
func _on_released():
	label.hide()
	
func _on_pressed():
	label.show()
	
func _process(delta):
	if label.visible:
		label.percent_visible = clamp(label.percent_visible + 0.5*(delta/duration), 0.0,1.0)
	else:
		label.percent_visible = 0.0
		

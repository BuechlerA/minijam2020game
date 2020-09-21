tool
extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var done = false;
const ELEMENTALS = ["FIRE","WATER","POISON","ICE","HUMAN"]

func _ready():
	if not done:
		done = true
		var thing = {}
		for element in ELEMENTALS:
			thing[element] = []
			var dir = Directory.new()
			var path = "res://assets/planetpallets/" + element 
			dir.open(path)
			dir.list_dir_begin()

			while true:
				var file = dir.get_next()
				if file == "":
					break

				if file.ends_with("png"):
					thing[element].append(path+"/"+file)
		
		var f = File.new()
		f.open("res://assets/planet_stuff/pallete_map.json", File.WRITE)
		f.store_string(to_json(thing))
		f.close()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

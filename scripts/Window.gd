extends Node

var pallete = [ 
	"f1f0ee",
	"ff4d4d",
	"9f1e31",
	"ffc438",
	"f06c00",
	"f1c284",
	"c97e4f",
	"973f3f",
	"57142e",
	"72cb25",
	"238531",
	"0a4b4d",
	"30c5ad",
	"2f7e83",
	"69deff",
	"33a5ff",
	"3259e2",
	"28237b",
	"c95cd1",
	"6c349d",
	"ffaabc",
	"e55dac",
	"17191b",
	"96a5ab",
	"586c79",
	"2a3747",
	"b9a588",
	"7e6352",
	"412f2f",
]

func generate_new_planet():
	randomize()
	var atmostphere = rand_range(0, len(pallete) - 1)
	var planet: Sprite = $PlanetImage
	$Planet.generate()
	$StarImage.texture = $Stars.get_texture()
	planet.texture = $Planet.get_texture()
	(planet.material as ShaderMaterial).set_shader_param("outline_color", Color(pallete[atmostphere]))
	$Stars/star/AnimationPlayer.play("spinnin")

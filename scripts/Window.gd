extends Node


func generate_new_planet(color, atmosphere):
	randomize()
	var planet: Sprite = $PlanetImage
	$Planet.generate(color)
	$StarImage.texture = $Stars.get_texture()
	planet.texture = $Planet.get_texture()
	(planet.material as ShaderMaterial).set_shader_param("outline_color", Color(atmosphere))
	$Stars/star/AnimationPlayer.play("spinnin")

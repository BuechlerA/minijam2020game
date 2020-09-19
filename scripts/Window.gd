extends Node

func generate_new_planet():
	$Planet.generate()
	$StarImage.texture = $Stars.get_texture()
	$PlanetImage.texture = $Planet.get_texture()
	$Stars/star/AnimationPlayer.play("spinnin")

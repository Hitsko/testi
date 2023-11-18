extends Node
var steps_grass = preload("res://Assets/Audio/footstep_grass_003.ogg")

func play_sfx(sfx_name: String):
	var asp = AudioStreamPlayer.new()
	
	var stream = null
	
	if sfx_name == "steps_grass":
		stream = steps_grass
	else:
		print("invalid sfx name")
		return

	asp.stream = stream 
	asp.name = "SFX" 
		
	add_child(asp)
		
	asp.play()
		
	await asp.finished
	asp.queue_free()

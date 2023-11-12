extends StaticBody2D

@onready var shadow = $Shadow

func _process(delta):
	z_index = global_position.y
	#shadow.z_index = global_position.y 

extends StaticBody2D

func _process(delta):
	# sets the objects layer in relation to the position on y axis
	z_index = global_position.y

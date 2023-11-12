extends PointLight2D
@onready var flash_light = $FlashLight 


func _process(delta):
	range_z_max = global_position.y 
	
	

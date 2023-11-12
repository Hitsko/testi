extends CharacterBody2D
@onready var player = $Player
@onready var light_rotation = $LightRotation
@export var speed = 200

func _ready():
	global_position.y = 0
	
func _process(delta):
	light_rotation.z_index = global_position.y
	z_index = global_position.y 
	#Comment
func _physics_process(delta):
	velocity = Vector2(0, 0)

	if Input.is_action_pressed("move_up"):
		velocity.y = -speed
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed

	light_rotation.look_at(get_global_mouse_position())
	
	move_and_slide()



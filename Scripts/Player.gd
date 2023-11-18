extends CharacterBody2D
@onready var foot_step_grass = $PlayerAudios/FootStepGrass
@onready var light_rotation = $LightRotation

@export var speed = 200


func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if is_multiplayer_authority():
		$CameraPosition/Camera2D.make_current()
		
func _process(delta):
	# sets the character layer in relation to the position on y axis
	z_index = global_position.y 
	
func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
	
		velocity = Vector2(0, 0)
		
		# Basic movement
		if Input.is_action_pressed("move_up"):
			velocity.y = -speed
			if Input.is_action_pressed("sneak"):
				velocity.y = -speed / 2
				
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
			if Input.is_action_pressed("sneak"):
				velocity.x = speed / 2
				
		if Input.is_action_pressed("move_down"):
			velocity.y = speed
			if Input.is_action_pressed("sneak"):
				velocity.y = speed / 2
				
		if Input.is_action_pressed("move_left"):
			velocity.x = -speed
			if Input.is_action_pressed("sneak"):
				velocity.x = -speed / 2
				
		# Changes the step volume between walking and sneaking
		if Input.is_action_pressed("sneak"):
			foot_step_grass.volume_db = -20
			foot_step_grass.max_distance = 1000
		else:
			foot_step_grass.volume_db = -10
		
		# Plays the walking animation when moving
		if velocity != Vector2(0, 0):
			$AnimationPlayer.play("Walk")
		else:
			$AnimationPlayer.stop()
		
		# Rotates the light in relation to the mouse position
		light_rotation.look_at(get_global_mouse_position())
		
		move_and_slide()

func play_footstep_audio():
	foot_step_grass.play
	

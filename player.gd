extends CharacterBody2D

@export var SPEED: int = 80
@export var FRICTION: int = 8
@export var JUMP_VELOCITY: int = -300.0
@export var JUMP_VELOCITY_ACCELERATION: int = -80

#onready var sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration. 
	# left = -1, idle = 0, right = 1 
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
		if direction == -1:
			$AnimatedSprite2D.flip_h = false
		elif direction == 1:
			$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		$AnimatedSprite2D.animation = "idle"

	# Handle Jump.
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			$Jump.play()
	else:
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY_ACCELERATION:
			velocity.y = JUMP_VELOCITY_ACCELERATION
			
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		$AnimatedSprite2D.animation = "jump"

	var was_mid_air = not is_on_floor() 
	move_and_slide()
	var is_just_landed = is_on_floor() && was_mid_air
	if is_just_landed:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.frame = 1

extends CharacterBody2D

@export var speed = 400
@export var fall_acceleration = 75

var target_velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# We create a local variable to store the input direction
	var direction = Vector2.ZERO
	
	# We check for each move input and update the direction accordingly
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.y = direction.y * speed

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

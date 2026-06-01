extends CharacterBody2D

@export var speed = 400
@export var fall_acceleration = 75
@export var bullet_scene: PackedScene
@export var weapons: Array[Weapon] = []
@export var weapon_delay_when_switching_seconds = 0.5

var time_to_fire = 0.0
var health = 100.0
var current_weapon_index = 0

signal on_death()

var active_weapon:
	get:
		if not weapons.is_empty():
			return weapons[current_weapon_index]
		return null

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
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire") and time_to_fire <= 0 and active_weapon:
		var bullet = bullet_scene.instantiate()
		bullet.setup(
			active_weapon,
			global_position,
			Vector2.UP,
			(1 << 1)
		)
		get_tree().current_scene.add_child(bullet)
		time_to_fire = 1.0 / active_weapon.fire_rate_per_second
	if Input.is_action_just_pressed("switch_weapon_previous"):
		current_weapon_index -= 1
		if current_weapon_index < 0:
			current_weapon_index = weapons.size() - 1
			if current_weapon_index < 0:
				current_weapon_index = 0
		GameplayUi.update_weapon(active_weapon);
	if Input.is_action_just_pressed("switch_weapon_next"):
		current_weapon_index += 1
		if current_weapon_index >= weapons.size():
			current_weapon_index = 0
		GameplayUi.update_weapon(active_weapon)
	if time_to_fire > 0:
		time_to_fire -= delta

func hit(damage: int):
	health -= damage
	GameplayUi.display_health(health)
	if health <= 0.0:
		on_death.emit()
		print("Died")

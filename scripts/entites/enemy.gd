extends Area2D

enum AttackBehavior {
	# Does not use weapons, still can run into player
	NONE,
	
	# Fires with weapon forward, if it has
	SHOOT_FORWARD,
	
	# Fires in the player's direction, difficult
	SHOOT_TOWARDS
}

enum MoveBehavior {
	# Just moves down, then off screen
	MOVE_DOWN,
	
	# Starts in the direction of player,
	# does not steer (goes off screen and deletes)
	MOVE_TO_PLAYER,
	
	# Starts in a random direction down, maybe to the 
	# left slightly, or to the right, or not.
	MOVE_RANDOM,
	
	# Stays on screen until player defeats it, strafes
	# to X coord of player
	STRAFE_TO_PLAYER
}

@export var score := 100
@export var speed = 100.0
@export var on_hit_damage = 20.0
@export var health := 100
@export var move_behavior := MoveBehavior.MOVE_DOWN
@export var attack_behavior := AttackBehavior.NONE
@export var voice: AudioStream
@export var time_for_talk_chance := 1.0

@export_category("Attack Properties")
@export var weapon: Weapon

@export_category("Strafe to Player Behavior")
@export var move_to_y := 100

@onready var audio := $AudioStreamPlayer2D

var talk_time := 0.0
var velocity = Vector2.ZERO

signal add_score(score_to_add: int)

func _ready() -> void:
	match move_behavior:
		MoveBehavior.MOVE_DOWN:
			velocity = Vector2.DOWN * speed
		MoveBehavior.MOVE_TO_PLAYER:
			# Find player
			var player = get_tree().get_first_node_in_group("Player")
			
			# If the player is still alive
			if player:
				velocity = (player.global_position - global_position).normalized() * speed
			else:
				velocity = Vector2.DOWN * speed
		MoveBehavior.MOVE_RANDOM:
			var x = randf_range(-1, 1)
			velocity = Vector2(x, 1).normalized() * speed
		MoveBehavior.STRAFE_TO_PLAYER: 
			velocity = Vector2.DOWN

func _physics_process(delta: float) -> void:
	if move_behavior != MoveBehavior.STRAFE_TO_PLAYER:
		global_position += velocity * delta
	else:
		if global_position.y < move_to_y:
			global_position += Vector2.DOWN * delta * speed
		else:
			var player = get_tree().get_first_node_in_group("Player")
			if player:
				if player.global_position.x < global_position.x:
					global_position += Vector2.LEFT * delta * speed
				else:
					global_position += Vector2.RIGHT * delta * speed
					
func _process(delta: float) -> void:
	talk_time -= delta
	if talk_time <= 0:
		talk_time = time_for_talk_chance
		if randf_range(0, 1) > 0.6:
			audio.stream = voice
			audio.play()
			
	
func hit(damage: int):
	health -= damage
	if health <= 0:
		die()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.hit(on_hit_damage)
		die()

func die():
	add_score.emit(score)
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Delete") and move_behavior != MoveBehavior.STRAFE_TO_PLAYER:
		queue_free()
		

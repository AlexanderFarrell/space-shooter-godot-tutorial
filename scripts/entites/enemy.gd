extends Area2D

@export var score := 100
@export var speed = 100.0
@export var on_hit_damage = 20.0
@export var health := 100

signal add_score(score_to_add: int)

func _physics_process(delta: float) -> void:
	global_position += Vector2.DOWN * speed * delta
	
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

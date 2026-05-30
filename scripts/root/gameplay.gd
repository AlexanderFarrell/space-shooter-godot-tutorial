extends Node

var score := 0
var next_spawn_chance := 0.0
var spawn_time := 0.5
var playing = true

@export var enemy: PackedScene

@onready var spawner_area = $World/SpawnArea/CollisionShape2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		AppManager.quit_to_menu()
		
	next_spawn_chance -= delta
	if next_spawn_chance < 0:
		next_spawn_chance = spawn_time
		_spawn_enemy()
		
func _spawn_enemy():
	var e = enemy.instantiate()
	var half_size = spawner_area.shape.size / 2.0
	$World.add_child(e)
	e.add_score.connect(_add_score)
	var x = randf_range(-half_size.x, half_size.x)
	var y = randf_range(-half_size.y, half_size.y)
	e.global_position = spawner_area.global_position + Vector2(x, y)


func _on_player_on_death() -> void:
	$World/Player.queue_free()
	playing = false
	GameplayUi.display_message_permanent("Game Over\nPress Escape to Quit")
	
func _add_score(score_to_add: int) -> void:
	score += score_to_add
	GameplayUi.display_score(score)

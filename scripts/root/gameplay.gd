extends Node

enum GameplayState {
	NEXT_LEVEL,
	WAVE_TRANSITION,
	WAVE_RUNNING,
	GAME_OVER,
	GAME_COMPLETE
}

var score := 0
var next_spawn_chance := 0.0
var spawn_time := 0.5
var current = GameplayState.NEXT_LEVEL

var level_index = -1
var wave_index = -1

var check_for_spawns_counter = 1.0

var active_level:
	get:
		if level_index < levels.size():
			return levels[level_index]
		return null
		
var active_wave:
	get:
		var level = active_level
		if level and wave_index < level.waves.size():
			return level.waves[wave_index]
		return null
		
var active_wave_run: Wave.Run

@export var enemy: PackedScene
@export var levels: Array[Level]

@onready var spawner_area = $World/SpawnArea/CollisionShape2D

func _ready() -> void:
	_change_to_state(GameplayState.NEXT_LEVEL)

func _change_to_state(state: GameplayState):
	current = state
	match current:
		GameplayState.NEXT_LEVEL:
			level_index += 1
			wave_index = -1
			# If there is still a level to play
			if active_level:
				# If there are still levels to play in the game
				GameplayUi.display_level(level_index + 1)
				GameplayUi.display_message("Level " + str(level_index + 1) + " - " + active_level.name, 3.0)
				await get_tree().create_timer(3.0).timeout
				_change_to_state(GameplayState.WAVE_TRANSITION)
			else:
				# You've beat the game
				_change_to_state(GameplayState.GAME_COMPLETE)
		GameplayState.WAVE_TRANSITION:
			wave_index += 1
			if active_wave:
				if active_wave.display_text != "":
					GameplayUi.display_message(active_wave.display_text, 3.0)
					await get_tree().create_timer(3.0).timeout
				active_wave_run = Wave.Run.new(active_wave)
				spawn_time = active_wave.spawn_speed
				_change_to_state(GameplayState.WAVE_RUNNING)
			else:
				_change_to_state(GameplayState.NEXT_LEVEL)
		GameplayState.WAVE_RUNNING:
			pass
		GameplayState.GAME_OVER:
			GameplayUi.display_message_permanent("Game Over\nPress Escape to Quit")
			$World/Player.queue_free()
		GameplayState.GAME_COMPLETE:
			GameplayUi.display_message_permanent("Phew... we escaped!\nPress Escape to Quit")
		

func _process(delta: float) -> void:
	match current:
		GameplayState.WAVE_RUNNING:
			next_spawn_chance -= delta
			if next_spawn_chance < 0:
				next_spawn_chance = spawn_time
				_spawn_from_wave()
			check_for_spawns_counter -= delta
			if check_for_spawns_counter <= 0:
				check_for_spawns_counter = 1.0
				if get_tree().get_first_node_in_group("Spawn") == null and active_wave_run.is_empty():
					_change_to_state(GameplayState.WAVE_TRANSITION)
				
		GameplayState.GAME_OVER, GameplayState.GAME_COMPLETE:
			if Input.is_action_pressed("pause"):
				AppManager.quit_to_menu()
		
func _spawn_from_wave():
	if active_wave_run.is_empty():
		return
	var e = active_wave_run.draw().instantiate()
	var half_size = spawner_area.shape.size / 2.0
	var x = randf_range(-half_size.x, half_size.x)
	var y = randf_range(-half_size.y, half_size.y)
	e.position = spawner_area.global_position + Vector2(x, y)
	$World.add_child(e)
	e.add_score.connect(_add_score)


func _on_player_on_death() -> void:
	_change_to_state(GameplayState.GAME_OVER)
	
func _add_score(score_to_add: int) -> void:
	score += score_to_add
	GameplayUi.display_score(score)

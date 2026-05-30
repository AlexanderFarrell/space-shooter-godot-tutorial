extends Resource
class_name Wave

@export var display_text: String
@export var spawn_speed := 2.0
@export var spawn_table_entries: Array[SpawnTableEntry]

class Run:
	var spawn_deck: Array[PackedScene] = []
	
	func _init(wave: Wave):
		for entry in wave.spawn_table_entries:
			for _i in range(entry.amount):
				spawn_deck.push_back(entry.packed_scene_to_spawn)
		spawn_deck.shuffle()
		
	func draw():
		return spawn_deck.pop_back()
	
	func is_empty():
		return spawn_deck.is_empty()
		
	func size():
		return spawn_deck.size()

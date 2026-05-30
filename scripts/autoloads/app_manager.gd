extends Node

var isPlaying := false

func start_game():
	get_tree().change_scene_to_file("res://scenes/root/gameplay.tscn")
	isPlaying = true
	
func game_over(finalScore: int, finalLevel: int):
	isPlaying = false
	
func to_highscores():
	get_tree().change_scene_to_file("res://scenes/root/highscores.tscn")

func quit_to_menu():
	get_tree().change_scene_to_file("res://scenes/root/menu.tscn")
	
func quit_app():
	get_tree().quit()

extends Control



func _on_play_button_button_up() -> void:
	AppManager.start_game()

func _on_highscores_button_button_up() -> void:
	AppManager.to_highscores()

func _on_quit_button_button_up() -> void:
	AppManager.quit_app()

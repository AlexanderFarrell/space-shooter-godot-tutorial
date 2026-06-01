extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		unpause()
	
func unpause():
	get_tree().paused = false
	queue_free()

func _on_resume_pressed() -> void:
	unpause()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	AppManager.quit_to_menu()

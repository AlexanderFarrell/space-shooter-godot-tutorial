extends Node

signal s_display_message(message: String, life: float)
signal s_display_message_permanent(message: String)
signal s_display_score(score: int)
signal s_display_health(health: float)
signal s_display_level(level: int)
signal s_update_weapon(weapon: Weapon)

func display_message(message: String, life: float):
	s_display_message.emit(message, life)
	
func display_message_permanent(message: String):
	s_display_message_permanent.emit(message)
	
func display_score(score: int):
	s_display_score.emit(score)
	
func display_health(health: float):
	s_display_health.emit(health)

func display_level(level: int):
	s_display_level.emit(level)
	
func update_weapon(weapon: Weapon):
	s_update_weapon.emit(weapon)

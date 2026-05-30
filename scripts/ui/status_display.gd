extends HBoxContainer

@onready var health_display = $Health
@onready var score_display = $Score
@onready var level_display = $Level

func _ready() -> void:
	GameplayUi.s_display_health.connect(display_health)
	GameplayUi.s_display_score.connect(display_score)

func display_health(health: float) -> void:
	health_display.text = "Health: " + str(health).pad_decimals(0)

func display_score(score: int):
	score_display.text = "Score: " + str(score)

func display_level(level: int):
	level_display.text = "Level: "+ str(level)

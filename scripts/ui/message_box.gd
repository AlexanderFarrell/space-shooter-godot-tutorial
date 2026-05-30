extends Label

var message_life = 0.0
var is_message_temporary = true

func _ready() -> void:
	GameplayUi.s_display_message.connect(display_message)
	GameplayUi.s_display_message_permanent.connect(display_message_permanent)
	
func _process(delta: float) -> void:
	if is_message_temporary:
		message_life -= delta
		if message_life <= 0:
			text = ""
			# Just an optimization
			is_message_temporary = false

func display_message(message: String, life: float):
	text = message
	message_life = life
	is_message_temporary = true
	
func display_message_permanent(message: String):
	text = message
	is_message_temporary = false

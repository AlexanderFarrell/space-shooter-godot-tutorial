extends HBoxContainer

@onready var image_display = $TextureRect
@onready var text_display = $Label

func _ready() -> void:
	GameplayUi.s_update_weapon.connect(update_weapon)

func update_weapon(weapon: Weapon) -> void:
	if weapon:
		if weapon.weapon_texture:
			image_display.texture = weapon.weapon_texture
		text_display.text = weapon.name
	else:
		image_display.texture = null
		text_display.text = "No Weapon Equipped"

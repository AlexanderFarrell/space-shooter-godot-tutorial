extends Area2D

var weapon: Weapon
var direction: Vector2
var life := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func setup(weapon_data: Weapon, pos: Vector2, dir: Vector2, mask: int):
	weapon = weapon_data
	global_position = pos
	direction = dir
	life = weapon.lifetime
	collision_mask = mask

func _ready() -> void:
	if weapon.bullet_texture:
		sprite.texture = weapon.bullet_texture
		
	var circle := CircleShape2D.new()
	circle.radius = weapon.radius
	collision_shape.shape = circle
	
func _physics_process(delta: float) -> void:
	global_position += direction * weapon.speed * delta
	life -= delta
	if life <= 0:
		queue_free()

func _on_area_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(weapon.damage)
	queue_free()

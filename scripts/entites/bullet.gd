extends Area2D

var weapon: Weapon
var direction: Vector2
var life := 0.0
var player: AudioStreamPlayer2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var audio := $AudioStreamPlayer2D

func setup(weapon_data: Weapon, pos: Vector2, dir: Vector2, mask: int):
	weapon = weapon_data
	global_position = pos
	direction = dir
	life = weapon.lifetime
	collision_mask = mask
	player = AudioStreamPlayer2D.new()

func _ready() -> void:
	if weapon.bullet_texture:
		sprite.texture = weapon.bullet_texture
		
	var circle := CircleShape2D.new()
	circle.radius = weapon.radius
	collision_shape.shape = circle
	
	if weapon.fire_sound:
		audio.stream = weapon.fire_sound
		audio.play()
	
func _physics_process(delta: float) -> void:
	global_position += direction * weapon.speed * delta
	life -= delta
	if life <= 0:
		queue_free()

func _on_area_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(weapon.damage)
	on_hit()
	
func on_hit():
	if weapon.hit_sound == null:
		return
	var external_player := AudioStreamPlayer2D.new()
	get_tree().current_scene.add_child(external_player)
	
	external_player.global_position = position
	external_player.stream = weapon.hit_sound
	external_player.play()
	
	external_player.finished.connect(external_player.queue_free)
	queue_free()

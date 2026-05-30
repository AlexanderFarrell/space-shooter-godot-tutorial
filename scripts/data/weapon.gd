extends Resource
class_name Weapon

enum BulletResource {
	ENERGY,
	AMMO,
	INFINITE
}

@export_group("Base Weapon Stats")
@export var name: String
@export var speed := 800.0
@export var damage := 10
@export var lifetime := 3
@export var bullet_texture: Texture2D
@export var weapon_texture: Texture2D
@export var fire_rate_per_second := 2
@export var radius := 1.0
@export var resource_type := BulletResource.INFINITE
@export var fire_sound: AudioStream
@export var hit_sound: AudioStream

@export_group("Energy")
@export var energy_use := 2.0

@export_group("Ammo")
@export var ammo_use := 1.0
@export var max_ammo := 500.0

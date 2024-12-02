extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
var laser = load("res://Scenes/Enemies/laser.tscn")
var health: int = 3
var firerate = 6

func _ready() -> void:
	shoot()

func apply_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()

func shoot():
	while shoot:
		animated_sprite_2d.play("attack")
		await get_tree().create_timer(firerate).timeout
		var laser_shooting = laser.instantiate()
		add_child(laser_shooting)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)

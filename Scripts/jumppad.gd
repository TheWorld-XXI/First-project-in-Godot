extends Area2D

@export var force = -1000.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().velocity.y = force
		animated_sprite_2d.play("idle")

func _on_area_exited(area):
	if area.get_parent() is Player:
		animated_sprite_2d.play("active")

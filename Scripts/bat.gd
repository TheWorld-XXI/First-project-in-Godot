extends CharacterBody2D


var speed = 175.0
var direction = 1


@onready var ray_cast_up = $RayCastUp
@onready var ray_cast_down = $RayCastDown
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Player = null

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if ray_cast_up.is_colliding() == true and direction == -1:
		direction = 1
	if ray_cast_down.is_colliding() == true and direction == 1:
		direction = -1

	velocity.y = speed * direction
	move_and_slide()
	animated_sprite.flip_h = direction == -1

	
var health: int = 5

func apply_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)

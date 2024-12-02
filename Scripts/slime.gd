extends CharacterBody2D

var speed = 80.0
var direction = 1

@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_down = $RayCastDown

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if ray_cast_down.is_colliding() == false:
		direction = direction * -1
		ray_cast_down.position.x *= -1
		
	if is_on_wall():
		direction = direction * -1
		animated_sprite.flip_h = direction == -1
		
	velocity.x = speed * direction
	move_and_slide()

var health: int = 3

func apply_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)
		

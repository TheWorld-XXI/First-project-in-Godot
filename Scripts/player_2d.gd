extends CharacterBody2D

class_name Player

@export var speed = 200.0
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1
@export var jump_force = -600.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5
@export var coyote_time = 0.2 

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var climb_speed = 150
var coyote_timer = 0 
var max_health = 3
var health = 0
var can_take_damage = true
var is_damaged = false  
var damage_dealing = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  

func _ready():
	Global.player = self
	health = max_health
	Global.lives = Global.max_lives

func _physics_process(delta):
	# Add gravity if the player is not on the floor and is not climbing
	if not is_on_floor() and not Global.is_climbing:
		velocity.y += gravity * delta
		coyote_timer += delta
	else:
		coyote_timer = 0 

	if Global.is_climbing:
		velocity.x = 0
		
		
		if Input.is_action_pressed("Up"):
			velocity.y = -climb_speed
		elif Input.is_action_pressed("Down"):
			velocity.y = climb_speed
		else:
			velocity.y = 0 

		gravity = 0
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		velocity.y += gravity * delta


	if Input.is_action_pressed("Attack") and not Global.is_attacking:
		Global.is_attacking = true 
		attack()

	if Global.is_attacking and !$AnimatedSprite2D.is_playing():
		Global.is_attacking = false


	var direction = Input.get_axis("Move left", "Move right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
		animated_sprite_2d.flip_h = direction == -1 
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration)


	if is_damaged:
		animated_sprite_2d.play("Damaged")
	elif Global.is_attacking:
		animated_sprite_2d.play("Attack")
	elif is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("Walk")
	elif not is_on_floor():
		animated_sprite_2d.play("Fall")

	move_and_slide()

	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() or coyote_timer <= coyote_time:
			velocity.y = jump_force
			animated_sprite_2d.play("Jump") 
			if coyote_timer <= coyote_time:
				coyote_timer = 0

	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release

func iframe():
	can_take_damage = false
	await get_tree().create_timer(0.5).timeout
	can_take_damage = true
	is_damaged = false

func _on_hurtbox_area_entered(hitbox):
	var base_damage = hitbox.damage
	self.hp -= base_damage

func attack():
	var projectile = preload("res://Scenes/Enemies/slash.tscn").instantiate()
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - global_position).normalized()
	projectile.global_position = global_position
	projectile.rotation = direction_to_mouse.angle()
	projectile.velocity = direction_to_mouse * projectile.SPEED
	get_parent().add_child(projectile)

func take_damage(damage_amount: int):
	if can_take_damage:
		iframe()
		health -= damage_amount
		is_damaged = true
		animated_sprite_2d.play("Damaged")
		if health <= 0:
			die()

func die():
	if Global.lives >= 0:
		Global.respawn_player()
	else:
		Global.player.queue_free()
		print("You died")
		Global.defeat = true

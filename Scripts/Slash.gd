extends CharacterBody2D

var SPEED: int = 300
var max_distance: float = 120.0  # Максимальное расстояние (50 клеток)
var traveled_distance: float = 0.0  # Пройденное расстояние
var initial_position: Vector2
var slash_direction 

@onready var sprite = $AnimatedSprite2D

func _ready():
	initial_position = global_position  # Сохраняем начальную позицию снаряда

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)  # Направление движения снаряда
	global_position += SPEED * direction * delta  # Двигаем снаряд
	traveled_distance = global_position.distance_to(initial_position)
	# Если снаряд прошел больше, чем 50 клеток, уничтожаем его
	if traveled_distance >= max_distance:
		queue_free()

func slash_direction_func():
	if slash_direction != 0:
		velocity.x = move_toward(velocity.x, slash_direction, SPEED)
		sprite.flip_h = slash_direction == -1  # Flip character based on direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

var damage: int = 1


func _on_area_2d_body_entered(body: Object) -> void:
	if body.is_in_group("enemy") and body.has_method("apply_damage"):
		body.apply_damage(damage)
		print("Damage applied")

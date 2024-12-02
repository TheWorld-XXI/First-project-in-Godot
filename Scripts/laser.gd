extends CharacterBody2D

var SPEED: int = 200
var max_distance: float = 600.0  # Максимальное расстояние (50 клеток)
var traveled_distance: float = 0.0  # Пройденное расстояние
var initial_position: Vector2

@onready var sprite = $AnimatedSprite2D

func _ready():
	initial_position = global_position  # Сохраняем начальную позицию снаряда

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta  # Двигаем снаряд
	traveled_distance = global_position.distance_to(initial_position)
	# Если снаряд прошел больше, чем 50 клеток, уничтожаем его
	if traveled_distance >= max_distance:
		queue_free()
		

var damage: int = 1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)

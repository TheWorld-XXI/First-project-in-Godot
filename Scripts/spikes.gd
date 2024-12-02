extends Area2D


func _on_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)

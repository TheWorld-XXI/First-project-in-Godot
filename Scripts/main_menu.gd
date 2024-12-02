extends Control

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_test_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Global.tscn")

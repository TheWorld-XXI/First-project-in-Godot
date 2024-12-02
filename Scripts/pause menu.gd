extends Control

func resume():
	get_tree().paused = false

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_resume_pressed():
	resume()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

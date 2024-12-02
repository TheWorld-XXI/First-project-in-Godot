### Global.gd

extends Node2D
signal gained_coins()
signal health_changed()
var coins : int
var is_attacking = false
var is_climbing = false
var player : Player
var current_checkpoint : Checkpoint
var defeat = false
var max_lives = 3
var lives : int

func gain_coins():
	coins += 1
	emit_signal("gained_coins")

func restart_after_death():
	if defeat == true:
		queue_free()
		get_tree().reload_current_scene()



func respawn_player():
	player.health = player.max_health
	lives -= 1
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

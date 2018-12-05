extends Node2D


onready var anim = $anim

func set_walking():
	if anim.get_current_animation() != "walking":
		anim.play("walking")


func set_flying():
	if anim.get_current_animation() != "flying":
		anim.play("flying")


func set_standing():
	if anim.get_current_animation() != "standing":
		anim.play("standing")


func set_standing_with_hat():
	if anim.get_current_animation() != "standing_with_hat":
		anim.play("standing_with_hat")


func set_walking_with_hat():
	if anim.get_current_animation() != "walking_with_hat":
		anim.play("walking_with_hat")


func quack():
	game.sounds.play_audio("quack")

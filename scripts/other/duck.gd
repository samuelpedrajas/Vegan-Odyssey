extends Node2D


onready var anim = $anim

signal duck_tapped

func set_walking():
	if anim.get_current_animation() != "walking":
		anim.play("walking")


func set_flying():
	if anim.get_current_animation() != "flying":
		anim.play("flying")


func set_standing(with_post=false):
	if anim.get_current_animation() != "standing" and anim.get_current_animation() != "standing_with_post":
		if with_post and game.duck_counter >= 1:
			anim.play("standing_with_post_and_bubble")
		else:
			anim.play("standing_with_post")


func set_standing_with_hat():
	if anim.get_current_animation() != "standing_with_hat":
		anim.play("standing_with_hat")


func set_walking_with_hat():
	if anim.get_current_animation() != "walking_with_hat":
		anim.play("walking_with_hat")


func set_stand_to_fly():
	if anim.get_current_animation() != "stand_to_fly":
		anim.play("stand_to_fly")


func set_fly_to_stand():
	if anim.get_current_animation() != "stand_to_fly":
		anim.play_backwards("stand_to_fly")


func set_hand():
	$hand.show()


func hide_hand():
	if $hand.is_visible():
		$hand.hide()


func hand_fade_out():
	$hand/anim2.play("fade_out")


func quack():
	game.sounds.play_audio("quack")


func _on_click_area_gui_input(event):
	if event.is_action_pressed("click"):
		emit_signal("duck_tapped")

extends Node2D


onready var animation = get_node("animation")


func close():
	animation.play("close")
	yield(animation, "animation_finished")
	queue_free()


func open():
	set_position(cfg.RESET_WINDOW_POS)
	animation.play("open")


func _on_ok_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()
	game.restart_game()


func _on_cancel_button_pressed():
	if cfg.DEV_MODE:
		game.broccolis += 1
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_clickable_space_pressed():
	game.popup_layer.close()


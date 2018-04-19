extends "popup.gd"


func open():
	set_position(cfg.RESET_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.sounds.play_audio("click")
	game.restart_game()


func _on_cancel_button_pressed():
	if cfg.DEV_MODE:
		game.broccolis += 10
	game.sounds.play_audio("click")
	game.popup_layer.close()
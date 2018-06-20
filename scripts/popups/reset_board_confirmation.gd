extends "popup.gd"


var back_button = true


func open():
	set_position(game.cfg.RESET_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.sounds.play_audio("click")
	game.restart_game()


func _on_cancel_button_pressed():
	if game.cfg.DEV_MODE:
		game.broccolis += 10
	game.sounds.play_audio("click")
	game.popup_layer.close()

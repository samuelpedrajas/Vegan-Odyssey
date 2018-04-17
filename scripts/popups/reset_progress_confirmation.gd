extends "popup.gd"


func open():
	set_position(cfg.RESET_PROGRESS_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.reset_progress()
	game.sounds.play_audio("click")


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_clickable_space_pressed():
	game.popup_layer.close()


extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false


func open():
	set_position(game.cfg.RESET_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.sounds.play_audio("click")
	game.restart_game()


func _on_cancel_button_pressed():
	if game.cfg.DEV_MODE:
		# game.broccolis += 10
		# game.event_layer.start("broccoli_duck")
		game.event_layer.start("win")
	game.sounds.play_audio("click")
	game.popup_layer.close()

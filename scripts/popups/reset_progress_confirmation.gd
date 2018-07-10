extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false


func open():
	set_position(game.cfg.RESET_PROGRESS_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.reset_progress()
	game.sounds.play_audio("click")


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

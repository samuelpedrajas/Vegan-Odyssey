extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


func open():
	set_position(game.cfg.EXIT_WINDOW_POS)

	open_anim = "open_window"
	.open()


func _on_ok_button_pressed():
	game.save_game()
	game.sounds.play_audio("click")
	get_tree().quit()


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

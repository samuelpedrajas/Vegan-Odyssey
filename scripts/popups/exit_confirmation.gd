extends "popup.gd"


var back_button = true
var keep_previous = false


func open():
	set_position(game.cfg.EXIT_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.popup_layer.close()
	game.save_game()
	game.sounds.play_audio("click")
	get_tree().quit()


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

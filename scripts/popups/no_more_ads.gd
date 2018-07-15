extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


func open():
	set_position(game.cfg.NO_MORE_ADS_WINDOW_POS)
	.open()


func _on_ok_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

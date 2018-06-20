extends "popup.gd"


var back_button = true


func open():
	set_position(game.cfg.NO_MORE_ADS_WINDOW_POS)
	.open()


func _on_ok_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

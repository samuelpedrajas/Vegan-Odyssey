extends "popup.gd"


func open():
	set_position(game.cfg.OFFLINE_WINDOW_POS)
	.open()


func _on_ok_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

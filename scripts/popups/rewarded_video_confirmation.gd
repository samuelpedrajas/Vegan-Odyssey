extends "popup.gd"


func open():
	set_position(game.cfg.REWARDED_VIDEO_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.sounds.play_audio("click")
	admob.showRewardedVideo()
	game.popup_layer.close()


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

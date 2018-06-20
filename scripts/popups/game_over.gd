extends "res://scripts/popups/popup.gd"


var back_button = false


func open():
	set_position(game.cfg.GAME_OVER_WINDOW_POS)
	if game.revived:
		$"window/video_button/used".show()
		$"window/video_button/bg_disabled".show()
		$"window/video_button/bg".hide()
		$"window/video_button/video_btn".set_disabled(true)
	else:
		$"window/video_button/used".hide()
		$"window/video_button/bg_disabled".hide()
		$"window/video_button/bg".show()
		$"window/video_button/video_btn".set_disabled(false)
	.open()


func _on_go_back_btn_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_video_btn_pressed():
	$"/root".set_disable_input(true)
	game.event_layer.start("wait_for_rewarded_ad", admob.adRewarded3)
	game.sounds.play_audio("click")
	hide()
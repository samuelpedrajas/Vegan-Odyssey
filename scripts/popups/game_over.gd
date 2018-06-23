extends "res://scripts/popups/popup.gd"


var back_button = false
var add_to_show


func open():
	# determine add_to_show
	if game.current_max < 8:
		add_to_show = admob.adRewarded1
		$"window/video_button/n".set_text("+1")
	else:
		add_to_show = admob.adRewarded3
		$"window/video_button/n".set_text("+3")

	set_position(game.cfg.GAME_OVER_WINDOW_POS)
	if game.revived:
		# avoid the duck to appear until restarted
		game.event_layer.get_node("duck_ready").set_paused(true)
		game.event_layer.duck_ready = false
		$"window/video_button/used".show()
		$"window/video_button/bg_disabled".show()
		$"window/video_button/bg".hide()
		$"window/video_button/video_btn".set_disabled(true)
	else:
		game.board_layer.movements = 0
		$"window/video_button/used".hide()
		$"window/video_button/bg_disabled".hide()
		$"window/video_button/bg".show()
		$"window/video_button/video_btn".set_disabled(false)
	.open("game_over")


func _on_go_back_btn_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_video_btn_pressed():
	$"/root".set_disable_input(true)
	game.event_layer.start("wait_for_rewarded_ad", add_to_show)
	game.sounds.play_audio("click")
	hide()
	game.popup_layer.get_node("blur").hide()

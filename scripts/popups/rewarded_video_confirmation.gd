extends "popup.gd"

var broccoli_girl


func open(_broccoli_girl):
	broccoli_girl = _broccoli_girl
	var ad_to_show = broccoli_girl.ad_to_show
	var plus = get_node("window/amount/" + str(ad_to_show.amount))
	plus.show()
	set_position(game.cfg.REWARDED_VIDEO_WINDOW_POS)
	.open()


func close():
	broccoli_girl.show()
	.close()


func _on_ok_button_pressed():
	game.event_layer.start("wait_for_rewarded_ad", broccoli_girl.ad_to_show)

	game.sounds.play_audio("click")
	game.popup_layer.close(true, true)


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

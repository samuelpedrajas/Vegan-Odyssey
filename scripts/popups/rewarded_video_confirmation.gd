extends "popup.gd"

var ad_to_show


func open(_ad_to_show):
	ad_to_show = _ad_to_show
	var plus = get_node("window/amount/" + str(ad_to_show.amount))
	plus.show()
	set_position(game.cfg.REWARDED_VIDEO_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.event_layer.start("wait_for_rewarded_ad", ad_to_show)

	game.sounds.play_audio("click")
	game.popup_layer.close(true, true)


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

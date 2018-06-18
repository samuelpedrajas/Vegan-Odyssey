extends "popup.gd"

var broccoli_duck


func open(_broccoli_duck):
	broccoli_duck = _broccoli_duck
	broccoli_duck.hide()
	var ad_to_show = broccoli_duck.ad_to_show
	var plus = get_node("window/amount/" + str(ad_to_show.amount))
	plus.show()
	set_position(game.cfg.REWARDED_VIDEO_WINDOW_POS)
	.open()


func close():
	broccoli_duck.show()
	.close()


func _on_ok_button_pressed():
	game.event_layer.start("wait_for_rewarded_ad", broccoli_duck.ad_to_show)

	game.sounds.play_audio("click")
	game.popup_layer.close(true, true)


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func quack():
	game.sounds.play_audio("quack")

extends "popup.gd"


var back_button = true
var keep_previous = false
var broccoli_duck


func open(_broccoli_duck):
	broccoli_duck = _broccoli_duck
	broccoli_duck.hide()
	var ad_to_show = broccoli_duck.ad_to_show
	$"window/amount".set_text("+" + str(ad_to_show.amount))
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

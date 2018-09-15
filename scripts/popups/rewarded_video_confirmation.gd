extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true
var broccoli_duck


func setup(_broccoli_duck):
	broccoli_duck = _broccoli_duck
	broccoli_duck.hide()


func open():
	var ad_to_show = broccoli_duck.ad_to_show
	$"window/container/amount".set_text("+" + str(ad_to_show.amount))

	open_anim = "open_window"
	.open()


func close():
	broccoli_duck.show()

	close_anim = "close_window"
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


func rescale(s):
	$window.set_scale(Vector2(s, s))

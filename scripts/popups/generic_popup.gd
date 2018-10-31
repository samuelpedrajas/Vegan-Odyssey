extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


func open():
	open_anim = "open_window"
	.open()


func setup(params):
	$"window/title".set_text(params["title"])
	$"window/text".set_text(params["text"])


func _on_ok_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func rescale(s):
	$window.set_scale(Vector2(s, s))

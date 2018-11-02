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
	open_anim = "open_window"
	.open()


func close():
	broccoli_duck.show()

	close_anim = "close_window"
	.close()


func _on_ok_button_pressed():
	game.sounds.play_audio("click")


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func quack():
	if is_visible():
		game.sounds.play_audio("quack")


func rescale(s):
	$window.set_scale(Vector2(s, s))

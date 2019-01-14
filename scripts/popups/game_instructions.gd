extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true



func setup():
	pass


func open():
	open_anim = "open_instructions"
	.open()


func close():
	close_anim = "close_window"
	.close()


func rescale(s):
	$window.set_scale(Vector2(s, s))


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


onready var scroll_container = $"window/scroll_container"


func open():
	open_anim = "open_book"
	.open()


func close():
	close_anim = "close_book"
	.close()


func rescale(s):
	$window.set_scale(Vector2(s, s))
	$go_back.set_scale(Vector2(s, s))
	$go_back.set_right_pos()


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

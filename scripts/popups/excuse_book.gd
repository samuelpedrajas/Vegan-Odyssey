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


func _on_close_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func rescale(s):
	$window.set_scale(Vector2(s, s))
	$c/close_button.set_scale(Vector2(s, s))

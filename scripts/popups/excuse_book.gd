extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


onready var scroll_container = $"window/scroll_container"


func open():
	set_position(game.cfg.BOOK_WINDOW_POS)

	open_anim = "open_book"
	.open()


func _on_close_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

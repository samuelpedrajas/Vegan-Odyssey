extends "popup.gd"

var back_button = true
var keep_previous = false


onready var scroll_container = $"window/scroll_container"


func open():
	set_position(game.cfg.BOOK_WINDOW_POS)
	.open("open_book")


func close():
	.close("close_book")


func _on_close_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

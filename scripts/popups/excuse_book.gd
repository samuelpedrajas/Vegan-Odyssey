extends "popup.gd"

var back_button = true


onready var scroll_container = $"window/scroll_container"


func open():
	set_position(game.cfg.BOOK_WINDOW_POS)
	.open()


func _on_close_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

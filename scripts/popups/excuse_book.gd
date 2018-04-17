extends "popup.gd"


onready var scroll_container = get_node("window/scroll_container")


func open():
	set_position(cfg.BOOK_WINDOW_POS)
	.open()


func _on_close_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

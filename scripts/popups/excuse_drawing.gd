extends "popup.gd"


func open(excuse_index):
	var image_node = $"window/excuse_image"
	var excuse_sprite = game.cfg.EXCUSES[excuse_index - 1]["book_sprite"]
	image_node.set_texture(excuse_sprite)
	set_position(game.cfg.EXCUSE_WINDOW_POS)
	.open()


func _on_ok_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

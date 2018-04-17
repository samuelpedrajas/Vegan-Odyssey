extends "popup.gd"


func open():
	set_position(cfg.EXCUSE_WINDOW_POS)
	.open()


func setup(excuse_index):
	var image_node = $"window/excuse_image"
	var excuse_sprite = cfg.EXCUSES[excuse_index - 1]["book_sprite"]
	image_node.set_texture(excuse_sprite)


func _on_ok_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

extends Node2D


var excuse_index


func setup(_excuse_index, pos):
	excuse_index = _excuse_index
	var excuse_sprite = game.cfg.EXCUSES[excuse_index - 1]["book_sprite"]
	$excuse_image.set_texture(excuse_sprite)
	set_position(pos)


func _on_share_pressed():
	# if share was found, use it
	var share = get_parent().share
	if share != null:
		var from_file = game.cfg.EXCUSES[excuse_index - 1]["path"]
		var to_file = "user://excuse.png"

		# copy file
		var dir = Directory.new()
		dir.copy(from_file, to_file)

		yield(get_tree(), "idle_frame")
		share.sharePic(
			OS.get_user_data_dir() + "/excuse.png",
			"Vegan Oddysey",
			"Play Vegan Oddysey for iOS and Android.",
			"Play Vegan Oddysey for iOS and Android. Download it for free at http://www.veganodysseythegame.com."
		)


func _on_exit_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()

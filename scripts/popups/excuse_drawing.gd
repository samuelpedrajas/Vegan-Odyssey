extends "popup.gd"


var share = null
var excuse_index


func _ready():
	# initialize the share singleton if it exists
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")


func open(_excuse_index):
	excuse_index = _excuse_index
	var image_node = $"window/excuse_image"
	var excuse_sprite = game.cfg.EXCUSES[excuse_index - 1]["book_sprite"]
	image_node.set_texture(excuse_sprite)
	set_position(game.cfg.EXCUSE_WINDOW_POS)

	.open()


func _on_cancel_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_share_pressed():
	# if share was found, use it
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

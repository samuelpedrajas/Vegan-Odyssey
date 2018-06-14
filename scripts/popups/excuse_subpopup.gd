extends Node2D


var excuse_index

var first_pos = null
var actual_pos = null


func setup(_excuse_index, pos):
	excuse_index = _excuse_index
	var excuse_sprite = game.cfg.EXCUSES[excuse_index - 1]["book_sprite"]
	$excuse_image.set_texture(excuse_sprite)
	set_position(pos)


func _on_share_pressed():
	if not get_parent().blocked:
		return

	var share = get_parent().get_parent().get_parent().share
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


func _on_input_area_gui_input(event):
	if event.is_action_pressed("click") and first_pos == null:
		first_pos = event.position
		get_parent().blocked = true
	elif event.is_action_released("click"):
		first_pos = null
		get_parent().check_change()
		get_parent().blocked = false
	elif event is InputEventScreenDrag and first_pos != null:
		get_parent().swift(first_pos, event.position)


func _on_left_pressed():
	get_parent().goto_prev()


func _on_right_pressed():
	get_parent().goto_next()

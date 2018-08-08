extends Node2D


var excuse_index

var first_pos = null
var actual_pos = null


func setup(_excuse_index, pos, rect_limit_y):
	excuse_index = _excuse_index
	var excuse_sprite = game.lang.EXCUSES[excuse_index - 1]["book_sprite"]
	$excuse_image.set_texture(excuse_sprite)
	$"excuse_image/number".set_text(str(excuse_index))
	set_position(pos)

	# hide it by placing it under the viewport
	if game.highest_max < excuse_index:
		position.y = rect_limit_y
	else:
		position.y = 0

	# hide or show blocked and unblocked buttons
	$"left/left".modulate.a = 1
	$"left/left_blocked".hide()
	$"right/right".modulate.a = 1
	$"right/right_blocked".hide()
	if excuse_index == 1:
		$"left/left".modulate.a = 0
		$"left/left_blocked".show()
	if excuse_index == 9 or excuse_index == game.highest_max:
		$"right/right".modulate.a = 0
		$"right/right_blocked".show()



func _on_share_released():
	if not get_parent().blocked or not check_pressed($share):
		return

	game.sounds.play_audio("click")

	var share = get_parent().get_parent().get_parent().share
	if share != null:
		var from_file = game.lang.EXCUSES[excuse_index - 1]["path"]
		var to_file = "user://excuse.png"

		# copy file
		var dir = Directory.new()
		dir.copy(from_file, to_file)

		yield(get_tree(), "idle_frame")
		share.sharePic(
			OS.get_user_data_dir() + "/excuse.png",
			game.lang.TITLE,
			game.lang.SUBJECT,
			game.lang.MSG
		)


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


func check_pressed(btn):
	var mouse_pos = get_viewport().get_mouse_position()
	var upper_left = btn.get_global_position()
	var lower_right = upper_left + btn.get_texture().get_size()
	return (
		mouse_pos.x > upper_left.x and mouse_pos.x < lower_right.x and
		mouse_pos.y > upper_left.y and mouse_pos.y < lower_right.y
	)


func _on_left_released():
	if check_pressed($"left/left"):
		get_parent().goto_prev(true)


func _on_right_released():
	if check_pressed($"right/right"):
		get_parent().goto_next(true)

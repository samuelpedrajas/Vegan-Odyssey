extends Control

var tap_start_position

signal user_input


func _check_move(input_vector):
	if input_vector.length() > game.cfg.MOTION_DISTANCE:
		# Don't needed, but could improve performance?
		input_vector = input_vector.normalized()

		for direction in game.cfg.DIRECTIONS:
			# if the distance is smaller than the threshold, try to make a move
			if (direction.normalized() - input_vector).length() < game.cfg.MINIMUM_DISTANCE_TO_MOVE:
				# close post
				if game.event_layer.current_events.has("tutorial"):
					game.event_layer.get_or_start("tutorial").unpost()
				emit_signal("user_input", direction)
				break


func _gui_input(event):
	if event.is_action_pressed("click"):
		# if clicked, save the position
		tap_start_position = event.position
	elif event.is_action_released("click"):
		# if released, erase de position and check if we can make a move
		var got_the_info = tap_start_position != null and event.position != null
		if got_the_info:
			_check_move(event.position - tap_start_position)
			tap_start_position = null


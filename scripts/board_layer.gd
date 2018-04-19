extends CanvasLayer


# keep board state
var matrix = {}

# first positions in each direction line
var direction_pivots = {}

onready var tween = $"tween"

# for instancing tokens
onready var token = preload("res://scenes/token.tscn")


func _ready():
	if cfg.DEBUG_MODE:
		_debug_func()

	# only needed once
	_set_direction_pivots()


func _set_direction_pivots():
	# get all used cells in the current board
	var used_cells = $"tilemap".get_used_cells()

	# for each used cell, if it has no previous cell but it has a next one
	# for a given direction, then it is a pivot for that direction
	for cell_pos in used_cells:
		for direction in cfg.DIRECTIONS:
			var next_pos = (cell_pos + direction)
			var prev_pos = (cell_pos - direction)
			if next_pos in used_cells and !(prev_pos in used_cells):
				if !direction_pivots.has(direction):
					direction_pivots[direction] = []
				direction_pivots[direction].append(cell_pos)


func move_tokens(direction):
	var movement_in_board = false

	# for each pivot in this direction
	for pivot in direction_pivots[direction]:
		var movement_in_line = _move_line(pivot, direction).movement
		movement_in_board = movement_in_board or movement_in_line

	if movement_in_board:
		tween.start()
		tween.interpolate_callback(game, tween.get_runtime(), "check_game")

		if game.check_win() or game.check_game_over():
			get_tree().get_root().set_disable_input(true)
		else:
			# 1/3 -> 2, 2/3 -> 1
			var t = spawn_token(null, int(randi() % 3 == 1) + 1, true)
			# plays spawn animation a bit before the tween is finished
			tween.interpolate_callback(t.animation, tween.get_runtime() * 0.7, "play", "spawn")
	game.save_game()
	# debug purposes
	_print_matrix()


func _move_line(pos, direction):
	var line_changes = {
		"movement": false,
		"last_token": null,
		"last_valid_position": null
	}

	# 3 cases: current position has a token, current position is not valid and current position is
	# valid but it doesn't have a token
	if matrix.has(pos):
		var current_token = matrix[pos]
		var changes = _move_line(pos + direction, direction)
		var last_token = changes.last_token
		var dest = changes.last_valid_position

		# conditions for positioning and merging
		if last_token and (last_token.is_dying or last_token.level != current_token.level):
			dest -= direction
		elif last_token and !last_token.is_dying and last_token.level == current_token.level:
			# logging
			var id1 = str(current_token.get_instance_id())
			var id2 = str(last_token.get_instance_id())
			print("Merging " + id1 +" with " + id2)

			# update both tokens
			current_token.is_dying = true
			last_token.level += 1

		if pos != dest:
			matrix.erase(pos)
			var world_pos = $"tilemap".map_to_world(dest)
			var animation_time = current_token.move_to(world_pos)
			if current_token.is_dying:
				tween.interpolate_callback(last_token, animation_time, "merge")
				game.update_scores(last_token.level)
			else:
				matrix[dest] = current_token
				current_token.matrix_pos = dest

		# update line_changes information for the previous position in the recursion
		line_changes.movement = pos != dest
		line_changes.last_token = current_token
		line_changes.last_valid_position = dest
	elif not pos in $"tilemap".get_used_cells():
		line_changes.last_valid_position = pos - direction
	else:
		return _move_line(pos + direction, direction)

	return line_changes


func _get_empty_position():
	var available_positions = []

	# for each cell used in the board
	for cell in $"tilemap".get_used_cells():
		# if there is no token in it, add it to available positions
		if !matrix.has(cell):
			available_positions.append(cell)

	if available_positions.empty():
		return null

	randomize()  # otherwise it generates the same numbers
	return available_positions[randi() % available_positions.size()]


func check_moves_available():
	var used_cells = $"tilemap".get_used_cells()

	if matrix.keys().size() < used_cells.size():
		return true

	for current_cell in used_cells:
		for d in cfg.DIRECTIONS:
			var v = current_cell - d
			if matrix.has(v) and matrix[v].level == matrix[current_cell].level:
				return true
	return false


func spawn_token(pos=null, level=1, animate=true):
	pos = pos if pos != null else _get_empty_position()
	if pos == null:
		return

	var t = token.instance()
	matrix[pos] = t

	if not animate:
		t.set_scale(Vector2(1.0, 1.0))
	else:
		t.set_scale(Vector2(0.0, 0.0))

	t.setup($"tilemap".map_to_world(pos), pos, tween, level)
	$"tokens".add_child(t)

	return t


func save_info():
	var info = {}
	for key in matrix.keys():
		info[key] = matrix[key].save_info()
	return info


func load_info(matrix_info):
	# set tokens on their positions
	for key in matrix_info.keys():
		var token_info = matrix_info[key]
		var pos = Vector2(int(token_info["pos.x"]), int(token_info["pos.y"]))
		spawn_token(pos, int(token_info["level"]), false)


func reset():
	# remove all tokens from the tween
	tween.remove_all()
	# clear the matrix
	matrix.clear()

	# remove all tokens one by one
	for token in get_tree().get_nodes_in_group("token"):
		token.hide()
		token.queue_free()


########## DEBUG FUNCTIONS ##########


func _debug_func():
	var lvl = 1
	for i in range(0, 3):
		for j in range(0, 3):
			var t = token.instance()
			add_child(t)
			t.setup($"tilemap".map_to_world(Vector2(j, i)), Vector2(j, i), tween, lvl)
			lvl += 1


func _print_matrix():
	print('===========================')
	var i; var j;
	for i in range(3):
		var line = ""
		for j in range(3):
			var pos = Vector2(j, i)
			if matrix.has(pos):
				line += str(pow(2, matrix[pos].level)) + " "
				line += "(" + str(matrix[pos].get_instance_id()) + ")\t"
			else:
				line += '-       \t'

		print(line)
	print('===========================')
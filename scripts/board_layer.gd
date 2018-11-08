extends CanvasLayer


# keep board state
var matrix = {}

# first positions in each direction line
var direction_pivots = {}

# for instancing tokens
onready var token = preload("res://scenes/token.tscn")
onready var board = $board

var movements = 0


func _ready():
	# only needed once
	_set_direction_pivots()


func _set_direction_pivots():
	# get all used cells in the current board
	var used_cells = board.tilemap.get_used_cells()

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
		# spawn new token
		# 1/3 -> 2, 2/3 -> 1
		var lvl = min(game.current_max, int(randi() % 3 == 1) + 1)
		var t = spawn_token(null, lvl, true)
		if t != null:
			t.animation.play("spawn")

		movements += 1

		# 3 cases:
		# - win
		# - game over
		# - new excuse
		if not game.win:
			if game.start_time == null:
				game.start_time = OS.get_unix_time()
			var moves_available = check_moves_available()
			# win, game over, tutorial
			if game.current_max == cfg.GOAL:
				game.victory()
			elif not moves_available and game.broccolis == 0:
				game.game_over()
			elif not moves_available:
				if not game.seen_tutorial["3"]:
					game.event_layer.get_or_start("tutorial").post("3")
				game.hud_layer.glow_reset()
				game.hud_layer.glow_broccoli()

		# start movement
		for t in get_tree().get_nodes_in_group("token"):
			if t.is_moving and not is_processing():
				t.set_process(true)

		# try to save in cfg.ANIMATION_TIME + 0.2 seconds
		if game.save_game_timer.is_stopped():
			game.save_game_timer.start()


func _move_line(pos, direction):
	var line_changes = {
		"movement": false,
		"last_token": null,
		"last_valid_position": null
	}

	# 3 cases:
	# - current position has a token
	# - current position is not valid
	# - current position is valid but it doesn't have a token
	if matrix.has(pos):
		var current_token = matrix[pos]
		var changes = _move_line(pos + direction, direction)
		var last_token = changes.last_token
		var dest = changes.last_valid_position

		# conditions for positioning and merging
		if last_token and last_token.followed == null and last_token.level != 9 and last_token.level == current_token.level:
			# logging
			var id1 = str(current_token.get_instance_id())
			var id2 = str(last_token.get_instance_id())
			print("Merging " + id1 +" with " + id2)

			# update both tokens
			current_token.follow(last_token)
			last_token.level += 1

			matrix.erase(pos)
			game.update_scores(last_token.level)
		else:
			if last_token != null:
				dest -= direction

			if pos != dest:
				matrix.erase(pos)
				matrix[dest] = current_token
				current_token.move_to(dest)

		# update line_changes information for the previous position in the recursion
		line_changes.movement = pos != dest
		line_changes.last_token = current_token
		line_changes.last_valid_position = dest
	elif not pos in board.tilemap.get_used_cells():
		line_changes.last_valid_position = pos - direction
	else:
		return _move_line(pos + direction, direction)

	return line_changes


func _get_empty_position():
	var available_positions = []

	# for each cell used in the board
	for cell in board.tilemap.get_used_cells():
		# if there is no token in it, add it to available positions
		if !matrix.has(cell):
			available_positions.append(cell)

	if available_positions.empty():
		return null

	randomize()  # otherwise it generates the same numbers
	return available_positions[randi() % available_positions.size()]


func check_moves_available():
	var used_cells = board.tilemap.get_used_cells()

	if matrix.keys().size() < used_cells.size():
		return true

	for current_cell in used_cells:
		for d in cfg.DIRECTIONS:
			var v = current_cell - d
			if matrix.has(v) and matrix[v].level == matrix[current_cell].level:
				return true
	return false


func spawn_token(pos=null, level=1, animate=false):
	pos = pos if pos != null else _get_empty_position()
	if pos == null:
		return

	var sc = Vector2(0, 0) if animate else Vector2(1, 1)
	var t = token.instance()
	t.set_process(false)

	matrix[pos] = t
	t.setup(board.tilemap.map_to_world(pos), pos, level, sc)
	board.tokens.add_child(t)

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
	# clear the matrix
	matrix.clear()

	# remove all tokens one by one
	for token in get_tree().get_nodes_in_group("token"):
		token.hide()
		token.queue_free()


########## DEBUG FUNCTIONS ##########


func debug_func():
	var lvl = 1
	for i in range(0, 3):
		for j in range(0, 3):
			spawn_token(Vector2(i, j), lvl, false)
			lvl += 1
	game.highest_max = 9


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

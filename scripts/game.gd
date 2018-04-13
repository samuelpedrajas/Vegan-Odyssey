extends Node

# game scores
var highest_max = cfg.MIN_HIGHEST_MAX
var current_max = 1
var highest_score = 0 setget _set_highest_score
var current_score = 0 setget _set_current_score

# items
var broccolis = 3 setget _set_broccolis

# keep board state
var matrix = {}

# child nodes
onready var board = $"board_layer/board"
onready var input_handler = $"input_handler"
onready var tween = $"tween"
onready var transition = $"transition"
onready var music = $"music"
onready var sounds = $"sounds"

# first positions in each direction line
var direction_pivots = {}

# signals
signal highest_score_changed
signal current_score_changed
signal broccoli_number_changed

# for instancing tokens
onready var token = preload("res://scenes/token.tscn")


func _ready():
	if cfg.DEBUG_MODE:
		_debug_func()
		return

	# only needed once
	_set_direction_pivots()


func new_game():
	spawn_token()
	input_handler.blocked = false


func _set_direction_pivots():
	# get all used cells in the current board
	var used_cells = board.get_used_cells()

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


### GAME LOOP ###


func game_loop():
	# update score and update token state
	for token in get_tree().get_nodes_in_group("token"):
		if token.is_merging():
			# manage scores
			var achieved_level = token.level + 1
			self.current_score += pow(2, achieved_level)
			self.highest_score = highest_score if highest_score > current_score else current_score
			self.current_max = achieved_level if achieved_level > current_max else current_max
			self.highest_max = current_max if current_max > highest_max else highest_max
		token.update_state()

	g.save_game()

	# have you won?
	if current_max == cfg.GOAL:
		win()
	else:
		var lvl = int(randi() % 3 == 1) + 1  # 1/3 -> 2, 2/3 -> 1
		spawn_token(lvl)
		if not _check_moves_available() and broccolis == 0:
			game_over()
		input_handler.blocked = false


func _get_empty_position():
	var available_positions = []

	# for each cell used in the board
	for cell in board.get_used_cells():
		# if there is no token in it, add it to available positions
		if !matrix.has(cell):
			available_positions.append(cell)

	if available_positions.empty():
		return null

	randomize()  # otherwise it generates the same numbers
	return available_positions[randi() % available_positions.size()]


func _check_moves_available():
	var used_cells = board.get_used_cells()

	if matrix.keys().size() < used_cells.size():
		return true

	for current_cell in used_cells:
		for d in cfg.DIRECTIONS:
			var v = current_cell - d
			if matrix.has(v) and matrix[v].level == matrix[current_cell].level:
				return true
	return false


### GAME FUNCTIONS ###


func spawn_token(level=1):
	var pos = _get_empty_position()
	if pos == null:
		return

	var t = token.instance()
	board.add_child(t)  # t.setup() needs access to the board, so add it before
	t.setup(pos, tween, level)
	matrix[pos] = t

	return t


func use_broccoli(token):
	if broccolis > 0:
		self.broccolis -= 1
		sounds.play_audio("click")
		matrix.erase(token.current_pos)
		token.die()

	if broccolis == 0 and g.current_event:
		print("no more broccolis")
		g.stop_event()

	if matrix.empty():
		var t = spawn_token()
		t.set_selectable_state()
		t.get_node("broccoli_spawn").set_active(true)


func restart_current_game():
	# here the screen is already black
	self.current_score = 0
	self.current_max = 1
	# remove all tokens from the tween
	tween.remove_all()
	# clear the matrix
	matrix.clear()

	# remove all tokens one by one
	for token in get_tree().get_nodes_in_group("token"):
		token.hide()
		token.queue_free()


func reset_progress():
	restart_current_game()

	# update other amounts
	self.highest_max = cfg.MIN_HIGHEST_MAX
	self.highest_score = 0
	self.broccolis = 0


### SAVE / LOAD FUNCTIONS ###


func save():
	var info = {}
	for key in matrix.keys():
		info[key] = matrix[key].save()  # this is implemented in token.gd
	return info


func load_game(info):
	self.highest_score = info['highest_score']
	self.highest_max = info['highest_max']
	self.current_score = info['current_score']
	self.current_max = info['current_max']
	self.broccolis = info['broccolis']

	# set tokens on their positions
	var m = info["matrix"]
	for key in m.keys():
		var t = token.instance()
		var token_info = m[key]
		var current_pos = Vector2(int(token_info["pos.x"]), int(token_info["pos.y"]))
		board.add_child(t)  # t.setup() needs access to the board, so add it before
		t.setup(current_pos, tween, int(token_info["level"]))
		matrix[current_pos] = t

	input_handler.blocked = false


### SETTERS ###


func _set_current_score(v):
	current_score = v
	emit_signal("current_score_changed", current_score)


func _set_highest_score(v):
	highest_score = v
	emit_signal("highest_score_changed", highest_score)


func _set_broccolis(v):
	broccolis = v
	emit_signal("broccoli_number_changed", broccolis)


### GAME MECHANICS ###


func move_tokens(direction):
	# information about the events in the board
	var board_changed = {
		"movement": false,  # did the tokens moved?
		"merge": false  # did any token merged with another one?
	}

	# for each pivot in this direction
	for pivot in direction_pivots[direction]:
		var line_changes = _move_line(pivot, direction)
		# update board information
		board_changed.movement = board_changed.movement or line_changes.movement
		board_changed.merge = board_changed.merge or line_changes.merge

	if board_changed.merge:
		# play merge sound if there was at least one merge in the board
		sounds.play_audio("merge")

	if board_changed.movement:
		input_handler.blocked = true
		tween.start()
		# When the animation of all tokens is finished -> prepare next round
		tween.interpolate_callback(self, tween.get_runtime(), "game_loop")


func _move_line(position, direction):
	var line_changes = {
		"movement": false,
		"merge": false,
		"last_token": null,
		"last_valid_position": null
	}

	# 3 cases: current position has a token, current position is not valid and current position is
	# valid but it doesn't have a token
	if matrix.has(position):
		var current_token = matrix[position]
		var changes = _move_line(position + direction, direction)
		var last_token = changes.last_token
		var token_destination = changes.last_valid_position

		# conditions for positioning and merging
		if last_token and (last_token.token_to_merge_with or last_token.level != current_token.level):
			token_destination -= direction
		elif last_token and !last_token.token_to_merge_with and last_token.level == current_token.level:
			line_changes.merge = true
			current_token.token_to_merge_with = last_token

		# move current token after moving the ones after it
		_move_token(current_token, token_destination)

		# update line_changes information for the previous position in the recursion
		line_changes.movement = position != token_destination
		line_changes.merge = line_changes.merge or changes.merge
		line_changes.last_token = current_token
		line_changes.last_valid_position = token_destination
	elif !_is_valid_position(position):
		line_changes.last_valid_position = position - direction
	else:
		return _move_line(position + direction, direction)

	return line_changes


func _move_token(token, destination):
	if token.current_pos != destination:
		matrix.erase(token.current_pos)  # the token is not in that position anymore
		# update the token position in the matrix if it's not gonna be merged
		# (otherwise we'd override the token that's gonna be increased)
		if !token.token_to_merge_with:
			matrix[destination] = token
	
		token.current_pos = destination  # update the current position
		token.define_tweening()


func _is_valid_position(p):
	# check if the position is inside the board
	return p in board.get_used_cells()


### WIN / LOSE ###


func win():
	print("Win")
	g.restart_game()


func game_over():
	print("Game over")
	g.restart_game()



########## DEBUG FUNCTIONS ##########


func _debug_func():
	var lvl = 1
	for i in range(0, 3):
		for j in range(0, 3):
			var t = token.instance()
			board.add_child(t)
			t.setup(Vector2(j, i), tween, lvl)
			lvl += 1

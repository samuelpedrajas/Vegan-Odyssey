extends Node

var savegame = File.new()

# game scores
var highest_max = cfg.MIN_HIGHEST_MAX
var current_max = 1
var highest_score = 0 setget _set_highest_score
var current_score = 0 setget _set_current_score

# items
var broccolis = 3 setget _set_broccolis


# child nodes
onready var transition = $"/root/stage/transition"
onready var music = $"/root/stage/music"
onready var sounds = $"/root/stage/sounds"
onready var board_layer = $"/root/stage/board_layer"
onready var hud_layer = $"/root/stage/hud_layer"
onready var event_layer = $"/root/stage/event_layer"
onready var popup_layer = $"/root/stage/popup_layer"
onready var settings = $"/root/stage/settings"


func _ready():
	# prevent quitting using back button
	get_tree().set_quit_on_go_back(false)
	get_tree().get_root().set_disable_input(true)


func update_scores(token_level):
	self.current_score += pow(2, token_level)
	self.highest_score = highest_score if highest_score > current_score else current_score
	self.current_max = token_level if token_level > current_max else current_max
	self.highest_max = current_max if current_max > highest_max else highest_max


func checkpoint():
	save_game()

	# has the user won or lost?
	if check_win():
		win()
	elif check_game_over():
		game_over()


func use_broccoli(token):
	# disable input for bug prevention
	get_tree().get_root().set_disable_input(true)

	# use broccoli
	if broccolis > 0:
		self.broccolis -= 1
		sounds.play_audio("click")
		board_layer.matrix.erase(token.matrix_pos)
		token.die()
		yield(token, 'tree_exited')

	# no more broccoli -> exit
	if broccolis == 0:
		print("no more broccolis")
		event_layer.stop()

	# if empty -> new token
	if board_layer.matrix.empty():
		var t = board_layer.spawn_token()
		t.animation.play("spawn")
		yield(t.animation, 'animation_finished')
		t.set_selectable_state()

	get_tree().get_root().set_disable_input(false)


func restart_game(delete_progress=false):
	get_tree().get_root().set_disable_input(true)

	transition.play("close")
	# wait until screen is black
	yield(transition, 'animation_finished')

	# update amounts
	self.current_score = 0
	self.current_max = 1
	if delete_progress:
		self.highest_max = cfg.MIN_HIGHEST_MAX
		self.highest_score = 0
		self.broccolis = 0
		popup_layer.close_all()

	board_layer.reset()

	save_game()

	transition.play("open")
	yield(transition, "animation_finished")

	get_tree().get_root().set_disable_input(false)


func reset_progress():
	restart_game(true)


### SAVE / LOAD FUNCTIONS ###


func save_game():
	savegame.open(cfg.SAVE_GAME_PATH, File.WRITE)
	var game_status = {
		'broccolis': broccolis,
		'highest_max': highest_max,
		'highest_score': highest_score,
		'current_score': current_score,
		'current_max': current_max,
		'matrix': board_layer.save(),
		'sound_on': settings.sound_on,
		'music_on': settings.music_on
	}
	savegame.store_line(to_json(game_status))
	savegame.close()


func load_game():
	savegame.open("user://savegame.save", File.READ)
	var info = parse_json(savegame.get_line())

	self.highest_score = info['highest_score']
	self.highest_max = info['highest_max']
	self.current_score = info['current_score']
	self.current_max = info['current_max']
	self.broccolis = info['broccolis']
	settings.load(info)
	board_layer.load(info)

	savegame.close()


### SETTERS ###


func _set_current_score(v):
	current_score = v
	hud_layer.set_current_score(v)


func _set_highest_score(v):
	highest_score = v
	hud_layer.set_highest_score(v)


func _set_broccolis(v):
	broccolis = v
	hud_layer.set_broccoli_amount(v)


### WIN / LOSE ###


func check_win():
	return current_max == cfg.GOAL


func check_game_over():
	return not board_layer.check_moves_available() and broccolis == 0


func win():
	print("Win")
	restart_game()


func game_over():
	print("Game over")
	restart_game()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		sounds.play_audio("click")
		if not popup_layer.popup_stack.empty():
			popup_layer.close()
		elif event_layer.current_event:
			event_layer.stop()
		else:
			popup_layer.open("exit_confirmation")

extends Node

var savegame = File.new()

# game scores
var highest_max = 1  # TODO: use cfg.MIN_HIGHEST_MAX
var current_max = 1 setget _set_current_max

# items
var broccolis = 3 setget _set_broccolis


# child nodes
var transition
var music
var sounds
var board_layer
var hud_layer
var event_layer
var popup_layer
var effects_layer
var debate_layer
var settings
var dying_tokens
var cfg

var duck_counter = 0


func _ready():
	# prevent quitting using back button
	get_tree().set_quit_on_go_back(false)
	$"/root".set_disable_input(true)


func setup():
	transition = $"/root/stage/transition"
	music = $"/root/stage/music"
	sounds = $"/root/stage/sounds"
	board_layer = $"/root/stage/board_layer"
	hud_layer = $"/root/stage/hud_layer"
	event_layer = $"/root/stage/event_layer"
	popup_layer = $"/root/stage/popup_layer"
	settings = $"/root/stage/settings"
	effects_layer = $"/root/stage/effects_layer"
	cfg = $"/root/stage/cfg"
	dying_tokens = $"/root/stage/dying_tokens"
	debate_layer = $"/root/stage/debate_layer"


func update_scores(token_level):
	self.current_max = token_level if token_level > current_max else current_max
	self.highest_max = current_max if current_max > highest_max else highest_max


func restart_game(delete_progress=false):
	$"/root".set_disable_input(true)

	transition.play("close")
	# wait until screen is black
	yield(transition, 'animation_finished')

	# update amounts
	self.current_max = 1
	if delete_progress:
		self.highest_max = cfg.MIN_HIGHEST_MAX
	popup_layer.close_all()

	board_layer.reset()
	board_layer.spawn_token(null, 1, false)

	save_game()

	transition.play("open")
	yield(transition, "animation_finished")

	$"/root".set_disable_input(false)


func reset_progress():
	restart_game(true)


### SAVE / LOAD FUNCTIONS ###


func save_game():
	savegame.open(
		cfg.SAVE_GAME_PATH, File.WRITE
	)
	var game_status = {
		'broccolis': broccolis,
		'highest_max': highest_max,
		'current_max': current_max,
		'matrix': board_layer.save_info(),
		'settings': settings.save_info()
	}
	savegame.store_line(to_json(game_status))
	savegame.close()


func load_game():
	savegame.open(
		cfg.SAVE_GAME_PATH, File.READ
	)
	var info = parse_json(savegame.get_line())


	self.highest_max = info['highest_max']
	current_max = info['current_max']
	self.broccolis = info['broccolis']
	settings.load_info(info['settings'])
	board_layer.load_info(info['matrix'])

	savegame.close()


### SETTERS ###


func _set_broccolis(v):
	broccolis = v
	hud_layer.set_broccoli_amount(v)


func _set_current_max(v):
	if current_max != v:
		debate_layer.update_text(v)
	current_max = v


func secretly_set_broccolis(amount):
	broccolis = amount


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
		if $"/root".is_input_disabled():
			return

		sounds.play_audio("click")
		if not popup_layer.popup_stack.empty():
			popup_layer.close()
		elif event_layer.closeable_event():
			event_layer.stop_closeables()
		else:
			popup_layer.open("exit_confirmation")

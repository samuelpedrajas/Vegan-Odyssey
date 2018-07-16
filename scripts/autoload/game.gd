extends Node

var savegame = File.new()

# game scores
var highest_max = 1  # TODO: use cfg.MIN_HIGHEST_MAX
var current_max = 1 setget _set_current_max

# items
var broccolis = 2 setget _set_broccolis


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
var revived = false
var seen_excuses = [
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false}
]
var en = preload("res://translations/en.gd").new()
var conversations = en.dialog_list
var ending = en.ending


var win = false


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


func recalculate_max():
	var tmp_max = 1
	for t in board_layer.matrix.values():
		if t.level > tmp_max:
			tmp_max = t.level
	self.current_max = tmp_max


func update_scores(token_level):
	self.current_max = token_level if token_level > current_max else current_max
	self.highest_max = current_max if current_max > highest_max else highest_max


func restart_game(delete_progress=false):
	$"/root".set_disable_input(true)

	transition.play("close")
	# wait until screen is black
	yield(transition, 'animation_finished')

	# update amounts
	revived = false
	win = false
	self.current_max = 1
	if delete_progress:
		self.highest_max = cfg.MIN_HIGHEST_MAX
		for excuse in seen_excuses:
			excuse.picture_seen = false
			excuse.debate_seen = false
	popup_layer.close_all()

	board_layer.reset()
	board_layer.spawn_token(null, 1, false)

	save_game()

	transition.play("open")
	yield(transition, "animation_finished")
	event_layer.get_node("duck_ready").set_paused(false)
	$"/root".set_disable_input(false)


func reset_progress():
	restart_game(true)


### SAVE / LOAD FUNCTIONS ###


func save_game():
	if OS.get_name() == "X11":
		savegame.open(
			cfg.SAVE_GAME_PATH, File.WRITE
		)
	else:
		print("Saving encrypted")
		savegame.open_encrypted_with_pass(
			cfg.SAVE_GAME_PATH, File.WRITE, OS.get_unique_id()
		)

	var game_status = {
		'broccolis': broccolis,
		'highest_max': highest_max,
		'current_max': current_max,
		'matrix': board_layer.save_info(),
		'settings': settings.save_info(),
		'revived': revived,
		'win': win,
		'seen_excuses': to_json(seen_excuses)
	}
	savegame.store_line(to_json(game_status))
	savegame.close()


func load_game():
	if OS.get_name() == "X11":
		savegame.open(
			cfg.SAVE_GAME_PATH, File.READ
		)
	else:
		print("Loading encrypted")
		savegame.open_encrypted_with_pass(
			cfg.SAVE_GAME_PATH, File.READ, OS.get_unique_id()
		)

	var info = parse_json(savegame.get_line())

	self.highest_max = info['highest_max']
	current_max = info['current_max']
	revived = info['revived']
	self.broccolis = info['broccolis']
	settings.load_info(info['settings'])
	board_layer.load_info(info['matrix'])
	win = info['win']
	seen_excuses = parse_json(info['seen_excuses'])

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
	if not win:
		$"/root".set_disable_input(true)
		win = true
		sounds.play_audio("prewin")

		var t = $"/root/stage/timer"
		t.set_wait_time(2.0)
		t.start()
		yield(t, "timeout")
		popup_layer.open("win")


func game_over():
	if not win:
		$"/root".set_disable_input(true)
		var t = $"/root/stage/timer"
		t.set_wait_time(0.4)
		t.start()
		yield(t, "timeout")

		sounds.play_audio("game_over")
		popup_layer.open("game_over")


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		if $"/root".is_input_disabled():
			return

		sounds.play_audio("click")
		if popup_layer.closeable():
			popup_layer.close()
		elif event_layer.closeable_event():
			event_layer.stop_closeables()
		elif popup_layer.popup_stack.empty():
			popup_layer.open("exit_confirmation")

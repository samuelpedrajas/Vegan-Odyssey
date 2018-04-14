extends Node


# POPUP MANAGMENT
var popup_stack = []
onready var popup_scene_dict = {
	"settings_menu": preload("res://scenes/popups/settings_menu.tscn"),
	"exit_confirmation": preload("res://scenes/popups/exit_confirmation.tscn"),
	"reset_confirmation": preload("res://scenes/popups/reset_confirmation.tscn"),
	"reset_progress_confirmation": preload("res://scenes/popups/reset_progress_confirmation.tscn"),
	"book": preload("res://scenes/popups/book.tscn"),
	"excuse_explanation": preload("res://scenes/popups/excuse_explanation.tscn")
}
onready var event_scene_dict = {
	"broccoli": preload("res://scenes/events/broccoli_selection.tscn")
}
var current_event

var savegame = File.new()

var game


func _ready():
	# prevent quitting using back button
	get_tree().set_quit_on_go_back(false)

	# prevent user_input
	get_tree().get_root().set_disable_input(false)

	game = get_tree().get_root().get_node("game")

	if !savegame.file_exists(cfg.SAVE_GAME_PATH):
		game.call_deferred("new_game")
	else:
		load_game()


func start_event(name):
	if not current_event:
		# disallow input until event is started
		get_tree().get_root().set_disable_input(true)

		current_event = event_scene_dict[name].instance()
		game.get_node("event_layer").add_child(current_event)
		current_event.start()

		yield(current_event.animation, "animation_finished")

		# animation is finished
		get_tree().get_root().set_disable_input(false)


func stop_event():
	# disallow input until event is started
	get_tree().get_root().set_disable_input(true)

	current_event.stop()

	yield(current_event, "tree_exited")
	current_event = null

	# animation is finished
	get_tree().get_root().set_disable_input(false)


func open_popup(name):
	# disallow input until the window is opened
	get_tree().get_root().set_disable_input(true)

	if not name in popup_stack:
		# pause everything
		if not popup_stack.empty():
			popup_stack.back().set_pause_mode(Node2D.PAUSE_MODE_STOP)
		else:
			get_tree().set_pause(true)

		var popup = popup_scene_dict[name].instance()
		popup.set_z_index(popup_stack.size())
		game.get_node("popup_layer").add_child(popup)
		popup.open()
		popup_stack.append(popup)
		yield(popup.animation, "animation_finished")
		get_tree().get_root().set_disable_input(false)
		# TODO:  fix this, used in scroll_container.gd
		return popup

	get_tree().get_root().set_disable_input(false)


func close_popup():
	# disallow input until the window is closed
	get_tree().get_root().set_disable_input(true)

	if not popup_stack.empty():
		var popup = popup_stack.back()
		popup_stack.pop_back()
		popup.close()
		yield(popup, "tree_exited")

	if popup_stack.empty():
		get_tree().set_pause(false)
	else:
		popup_stack.back().set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
	get_tree().get_root().set_disable_input(false)


func save_game():
	savegame.open(cfg.SAVE_GAME_PATH, File.WRITE)
	var game_status = {
		'broccolis': game.broccolis,
		'highest_max': game.highest_max,
		'highest_score': game.highest_score,
		'current_score': game.current_score,
		'current_max': game.current_max,
		'matrix': game.save(),
		'sound_on': settings.sound_on,
		'music_on': settings.music_on
	}
	savegame.store_line(to_json(game_status))
	savegame.close()


func load_game():
	savegame.open("user://savegame.save", File.READ)
	var game_status = parse_json(savegame.get_line())

	# set parameters
	settings.sound_on = game_status['sound_on']
	settings.music_on = game_status['music_on']

	# send the info to the game scene
	game.call_deferred("load_game", game_status)

	savegame.close()


func restart_game():
	get_tree().get_root().set_disable_input(true)

	game.transition.play("close")
	# wait until screen is black
	yield(game.transition, 'animation_finished')

	game.restart_current_game()

	game.spawn_token(null, 1, false)

	game.transition.play("open")
	yield(game.transition, "animation_finished")

	get_tree().get_root().set_disable_input(false)


func reset_progress():
	get_tree().get_root().set_disable_input(true)

	var dir = Directory.new()
	if dir.file_exists(cfg.SAVE_GAME_PATH):
		dir.remove(cfg.SAVE_GAME_PATH)

	game.transition.play("close")
	# wait until screen is black
	yield(game.transition, 'animation_finished')

	_close_popups()
	game.reset_progress()

	game.spawn_token(null, 1, false)

	game.transition.play("open")
	yield(game.transition, "animation_finished")

	get_tree().get_root().set_disable_input(false)


func _close_popups():
	while !popup_stack.empty():
		var popup = popup_stack.pop_back()
		popup.queue_free()
		yield(popup, 'tree_exited')
	get_tree().set_pause(false)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		game.sounds.play_audio("click")
		if not popup_stack.empty():
			close_popup()
		elif current_event:
			stop_event()
		else:
			open_popup("exit_confirmation")


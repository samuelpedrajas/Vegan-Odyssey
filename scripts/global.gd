extends Node


# POPUP MANAGMENT
var popup_stack = []
onready var popup_scene_dict = {
	"settings_menu": preload("res://scenes/settings_menu.tscn"),
	"exit_confirmation": preload("res://scenes/exit_confirmation.tscn"),
	"reset_confirmation": preload("res://scenes/reset_confirmation.tscn"),
	"reset_progress_confirmation": preload("res://scenes/reset_progress_confirmation.tscn"),
	"book": preload("res://scenes/book.tscn"),
	"excuse_explanation": preload("res://scenes/excuse_explanation.tscn")
}
onready var event_scene_dict = {
	"broccoli": preload("res://scenes/broccoli_selection.tscn")
}
var current_event

var savegame = File.new()

var game


func _ready():
	# prevent quitting using back button
	get_tree().set_quit_on_go_back(false)

	game = get_tree().get_root().get_node("game")

	load_game()


func start_event(name):
	if name == "broccoli":
		current_event = event_scene_dict[name].instance()
		game.get_node("event_layer").add_child(current_event)


func stop_event():
	if current_event != null:
		current_event.close()
		current_event = null
	else:
		print("SOMETHING WEIRD GOING ON")


func open_popup(name):
	if not name in popup_stack:
		get_tree().set_pause(true)
		# pause other windows
		if not popup_stack.empty():
			popup_stack.back().set_pause_mode(Node2D.PAUSE_MODE_STOP)

		var popup = popup_scene_dict[name].instance()
		popup.set_z_index(popup_stack.size())
		game.get_node("popup_layer").add_child(popup)
		popup_stack.append(popup)

		return popup


func close_popup():
	if not popup_stack.empty():
		var popup = popup_stack.back()
		popup_stack.pop_back()
		popup.close()

	if popup_stack.empty():
		get_tree().set_pause(false)
	else:
		popup_stack.back().set_pause_mode(Node2D.PAUSE_MODE_PROCESS)


func close_popups():
	while !popup_stack.empty():
		close_popup()


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
	if !savegame.file_exists(cfg.SAVE_GAME_PATH):
		game.call_deferred("new_game")
	else:
		savegame.open("user://savegame.save", File.READ)
		var game_status = parse_json(savegame.get_line())
		game.call_deferred("load_game", game_status)
		settings.sound_on = game_status['sound_on']
		settings.music_on = game_status['music_on']
		savegame.close()


func restart_game():
	game.input_handler.blocked = true

	game.transition.play("close")
	# wait until screen is black
	yield(game.transition, 'animation_finished')

	game.restart_current_game()

	var t = game.spawn_token()
	# wait until token spawns
	yield(t.animation, "animation_finished")

	game.transition.play("open")
	yield(game.transition, "animation_finished")

	game.input_handler.blocked = false


func reset_progress():
	var dir = Directory.new()
	if dir.file_exists(cfg.SAVE_GAME_PATH):
		dir.remove(cfg.SAVE_GAME_PATH)

	game.input_handler.blocked = true

	game.transition.play("close")
	# wait until screen is black
	yield(game.transition, 'animation_finished')

	close_popups()
	game.reset_progress()

	var t = game.spawn_token()
	# wait until token spawns
	yield(t.animation, "animation_finished")

	game.transition.play("open")
	yield(game.transition, "animation_finished")

	game.input_handler.blocked = false


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		play_audio("click")
		if not popup_stack.empty():
			close_popup()
		elif current_event:
			stop_event()
		else:
			open_popup("exit_confirmation")


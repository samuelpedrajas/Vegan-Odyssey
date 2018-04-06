extends Node


# POPUP MANAGMENT
var popup_stack = []
onready var popup_scene_dict = {
	"settings": preload("res://scenes/settings.tscn"),
	"exit_confirmation": preload("res://scenes/exit_confirmation.tscn"),
	"reset_confirmation": preload("res://scenes/reset_confirmation.tscn"),
	"book": preload("res://scenes/book.tscn"),
	"excuse_explanation": preload("res://scenes/excuse_explanation.tscn")
}
var current_event

# SETTINGS
var music_on = true setget _set_music_on
var music_node
var sound_on = true setget _set_sound_on
var merge_sound
var click_sound

var savegame = File.new()

var game
var transition


func _ready():
	# prevent quitting using back button
	get_tree().set_auto_accept_quit(false)

	game = get_tree().get_root().get_node("game")
	music_node = game.get_node("music")
	merge_sound = game.get_node("merge")
	click_sound = game.get_node("click")
	transition = game.get_node("transition")

	if not load_game():
		save_game()


func start_event(name):
	if name == "broccoli":
		current_event = game.start_broccoli_selection()


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
		g.game.get_node("popup_layer").add_child(popup)
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


func play_audio(sample):
	if sample == "merge":
		merge_sound.play()
	else:
		click_sound.play()


func save_game():
	savegame.open("user://savegame.save", File.WRITE)
	var game_status = {
		'highest_max': game.highest_max,
		'highest_score': game.highest_score,
		'music_on': music_on,
		'sound_on': sound_on
	}
	savegame.store_line(to_json(game_status))
	savegame.close()


func load_game():
	if !savegame.file_exists("user://savegame.save"):
		return false

	savegame.open("user://savegame.save", File.READ)
	var game_status = parse_json(savegame.get_line())
	game.highest_score = game_status['highest_score']
	game.highest_max = game_status['highest_max']
	self.music_on = game_status['music_on']
	self.sound_on = game_status['sound_on']
	savegame.close()


func _set_music_on(v):
	if v:
		music_node.play()
	else:
		music_node.stop()
	music_on = v


func _set_sound_on(v):
	if not v:
		merge_sound.bus = "Silence"
		click_sound.bus = "Silence"
	else:
		merge_sound.bus = "Master"
		click_sound.bus = "Master"
	sound_on = v


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		play_audio("click")
		if not popup_stack.empty():
			close_popup()
		elif current_event:
			stop_event()
		else:
			open_popup("exit_confirmation")


extends Node2D


var loader
var wait_frames
var n_frame = 0


var progress_bar
var snail

var scene_resource = null

var stop_the_snail = false

var translation_resource

const stage_scene_path = "res://scenes/game.tscn"

var iap_status = "no"


signal purchase_transaction_finished


func goto_stage(_progress_bar):
	progress_bar = _progress_bar
	snail = progress_bar.get_node("snail")
	var translation_file = game.get_translation_file_path()
	loader = ResourceLoader.load_interactive(translation_file)
	if loader == null:
		print("Error in game loader")
		return
	set_process(true)

	wait_frames = 50


func _process(time):
	# debug (tutorial post)
	if not snail:
		return

	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return

	# poll your loader
	var err = loader.poll()

	if err == ERR_FILE_EOF: # load finished
		if translation_resource != null:
			print("Main scene loading finished.")
			scene_resource = loader.get_resource()
			snail.position = Vector2(550, snail.position.y)
			loader = null

			if stop_the_snail:
				yield(self, "purchase_transaction_finished")

			game.set_new_scene(scene_resource, translation_resource, iap_status)
		else:
			print("Translation script loaded")
			translation_resource = loader.get_resource()
			loader = ResourceLoader.load_interactive(stage_scene_path)


	elif err == OK:
		if translation_resource == null:
			print("Loading translations...")
			update_progress(0.0, 0.05)
		else:
			print("Loading main scene...")
			update_progress(0.05, 1.0)
	else:
		loader = null
		print("Error in game loader")


var instructions_done = false


func update_progress(low, high):
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	progress *= (high - low) + low
	progress_bar.value = progress * 100

	snail.position = Vector2((550 - 100) * progress + 100, 81)
	print(progress)
	if not instructions_done and progress > 0.2:
		instructions_done = true
		in_between_instructions()


func in_between_instructions():
	if OS.get_name() == "iOS" and OS.get_screen_orientation() == OS.SCREEN_ORIENTATION_USER:
		var mobile_tools = Engine.get_singleton("MobileTools")
		if mobile_tools.isIphone():
			print("It's an iPhone")
			OS.set_screen_orientation(OS.SCREEN_ORIENTATION_PORTRAIT)
		else:
			print("It's an iPad")
			OS.set_screen_orientation(OS.SCREEN_ORIENTATION_SENSOR)
			mobile_tools.attemptRotationToDeviceOrientation()


func coming_from_app_store():
	if OS.get_name() == "iOS":
		var start_purchase = (
			ios_iap.coming_from_app_store() and
			(game.savegame_data == null or
			not game.savegame_data["purchased"])
		)
		if start_purchase:
			stop_the_snail = true
			print("Coming from App Store!!")

			ios_iap.connect("purchase_success", self, "on_purchase_success")
			ios_iap.connect("purchase_error", self, "on_purchase_error")
			ios_iap.continue_purchase()
			purchase_request_started = true


var purchase_request_started = false

func check_events():
	if purchase_request_started:
		ios_iap.check_events()
	elif translation_resource != null:
		coming_from_app_store()


func on_purchase_success():
	if game.savegame_data == null:
		game.save_game_defaults(translation_resource.lang, true)
	else:
		game.savegame_data["purchased"] = true
		game.save_game(game.savegame_data)
	stop_the_snail = false
	iap_status = "yes_success"
	emit_signal("purchase_transaction_finished")


func on_purchase_error():
	stop_the_snail = false
	iap_status = "yes_error"
	emit_signal("purchase_transaction_finished")

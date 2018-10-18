extends Node2D


var loader
var wait_frames
var n_frame = 0


var progress_bar
var snail

var scene_resource = null

const stage_scene_path = "res://scenes/game.tscn"


func goto_stage(_progress_bar):
	progress_bar = _progress_bar
	snail = progress_bar.get_node("snail")
	loader = ResourceLoader.load_interactive(stage_scene_path)
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
		if scene_resource == null:
			print("Main scene loading finished.")
			scene_resource = loader.get_resource()
			# get_translation_file_path sets savegame_data if a file is found
			var translation_file = game.get_translation_file_path()
			loader = ResourceLoader.load_interactive(translation_file)
		else:
			print("Translation script loaded")
			var translation_resource = loader.get_resource()
			loader = null
			snail.position = Vector2(550, snail.position.y)
			game.set_new_scene(scene_resource, translation_resource)
	elif err == OK:
		if scene_resource == null:
			print("Loading main scene...")
			update_progress(0.0, 0.95)
		else:
			print("Loading translations...")
			update_progress(0.95, 1.0)
	else:
		loader = null
		print("Error in game loader")


var do_rotate = true

func update_progress(low, high):
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	progress *= (high - low) + low
	progress_bar.value = progress * 100

	snail.position = Vector2((550 - 100) * progress + 100, 81)
	print(progress)

	if do_rotate and progress >= 0.2:
		if OS.get_name() == "iOS" and OS.get_screen_orientation() == OS.SCREEN_ORIENTATION_USER:
			var mobile_tools = Engine.get_singleton("MobileTools")
			if mobile_tools.isIphone():
				print("It's an iPhone")
				OS.set_screen_orientation(OS.SCREEN_ORIENTATION_PORTRAIT)
			else:
				print("It's an iPad")
				OS.set_screen_orientation(OS.SCREEN_ORIENTATION_SENSOR)
				mobile_tools.attemptRotationToDeviceOrientation()
		do_rotate = false

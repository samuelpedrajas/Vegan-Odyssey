extends Node2D


var loader
var wait_frames
var time_max = 100 # msec

var load_finished = false

var progress_bar


func goto_scene(path, _progress_bar):
	progress_bar = _progress_bar
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		print("Error in game loader")
		return
	set_process(true)

	wait_frames = 1


func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return

	# advance more than one stage in a single frame
	var t = OS.get_ticks_msec()
	while not load_finished and OS.get_ticks_msec() < t + time_max:

		# poll your loader
		var err = loader.poll()

		if err == ERR_FILE_EOF: # load finished
			load_finished = true
			break
		elif err == OK:
			update_progress()
		else:
			loader = null
			print("Error in game loader")
			break

	# is everything loaded?
	if admob.admob_ad_loaded and load_finished:
		var resource = loader.get_resource()
		loader = null
		set_new_scene(resource)


func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	progress_bar.value = progress * 100
	print(progress)


func set_new_scene(scene_resource):
	# remove old scene
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() -1)
	current_scene.queue_free()

	# set new scene
	var new_scene = scene_resource.instance()
	get_node("/root").add_child(new_scene)
	set_process(false)

extends Node2D


var loader
var wait_frames
var n_frame = 0

var progress = 0

var progress_bar
var snail


func goto_scene(path, _progress_bar):
	progress_bar = _progress_bar
	snail = progress_bar.get_node("snail")
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		print("Error in game loader")
		return
	set_process(true)

	wait_frames = 50


func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	move_snail()


	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return

	# poll your loader
	var err = loader.poll()

	if err == ERR_FILE_EOF: # load finished
		var scene_resource = loader.get_resource()
		loader = null
		snail.position = Vector2(550, snail.position.y)
		set_new_scene(scene_resource)
	elif err == OK:
		update_progress()
	else:
		loader = null
		print("Error in game loader")


func update_progress():
	progress = float(loader.get_stage()) / loader.get_stage_count()
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


func move_snail():
	snail.position = Vector2((550 - 100) * progress + 100, 81)
	n_frame = (n_frame + 1) % 10
	if n_frame == 4:
		snail.frame = (snail.frame + 1) % 5

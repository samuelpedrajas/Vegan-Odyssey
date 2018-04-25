extends CanvasLayer


var current_event
onready var event_scene_dict = {
	"broccoli": preload("res://scenes/events/broccoli_selection.tscn")
}


func start(name):
	if not current_event:
		# disallow input until event is started
		$"/root".set_disable_input(true)

		current_event = event_scene_dict[name].instance()
		add_child(current_event)
		current_event.start()


func stop():
	# disallow input until event is started
	$"/root".set_disable_input(true)

	current_event.stop()

	yield(current_event, "tree_exited")
	current_event = null

	# animation is finished
	$"/root".set_disable_input(false)
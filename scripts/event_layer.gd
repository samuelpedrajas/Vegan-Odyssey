extends CanvasLayer


var current_events = {}
onready var event_scene_dict = {
	"broccoli": preload("res://scenes/events/broccoli_selection.tscn"),
	"broccoli_girl": preload("res://scenes/events/broccoli_girl.tscn")
}


onready var programmmed_events = [
	{
		"event_name": "broccoli_girl",
		"time": game.cfg.BROCCOLI_GIRL_FREQUENCY
	}
]


func start(event_name):
	if not event_name in current_events:
		var event = event_scene_dict[event_name].instance()
		event.set_z_index(event.priority)
		current_events[event_name] = event
		add_child(event)
		move_child(event, 0)
		event.start()


func stop(event_name):
	var event = current_events[event_name]
	current_events.erase(event_name)

	event.stop()
	yield(event, "tree_exited")

	# animation is finished
	$"/root".set_disable_input(false)
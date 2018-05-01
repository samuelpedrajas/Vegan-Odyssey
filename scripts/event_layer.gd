extends CanvasLayer


var current_events = {}
onready var event_scene_dict = {
	"broccoli": preload("res://scenes/events/broccoli_selection.tscn"),
	"broccoli_girl": preload("res://scenes/events/broccoli_girl.tscn")
}

var run_programmed_events = true

onready var programmmed_events = [
	{
		"event_name": "broccoli_girl",
		"time": game.cfg.BROCCOLI_GIRL_FREQUENCY
	}
]


func _ready():
	start_programmed_events()


func start(event_name):
	if not event_name in current_events:
		var event = event_scene_dict[event_name].instance()
		event.set_z_index(event.priority)
		current_events[event_name] = event
		add_child(event)
		move_child(event, 0)
		event.start()
		return event
	return null


func start_programmed_events():
	for info in programmmed_events:
		start_programmed_event(info)


func start_programmed_event(info):
	# TODO: refactor this
	# start a new timer for this programmed event
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(info.time)

	while run_programmed_events:
		timer.start()
		yield(timer, "timeout")

		admob.loadRewardedVideo()
		yield(admob, "rewarded_ad_loaded")

		# run the event if it's not already running
		# the run_programmed_events property could have changed as well
		if (not info.event_name in current_events.keys() and
			run_programmed_events and admob.admob_rewarded_ad_loaded):  # todo: check this
			var event = start(info.event_name)
			if event != null:
				yield(event, "tree_exited")
	timer.queue_free()


func stop(event_name):
	var event = current_events[event_name]
	current_events.erase(event_name)

	event.stop()
	yield(event, "tree_exited")

	# animation is finished
	$"/root".set_disable_input(false)


func stop_closeables():
	for event_name in current_events.keys():
		var event = current_events[event_name]
		if event.closeable:
			stop(event_name)


func closeable_event():
	for event in current_events.values():
		if event.closeable:
			return true
	return false

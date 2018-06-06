extends Node2D


var current_events = {}
onready var event_scene_dict = {
	"broccoli": preload("res://scenes/events/broccoli_selection.tscn"),
	"broccoli_duck": preload("res://scenes/events/broccoli_duck.tscn"),
	"wait_for_rewarded_ad": preload("res://scenes/events/wait_for_rewarded_ad.tscn")
}


func start(event_name, params=null):
	if not event_name in current_events:
		var event = event_scene_dict[event_name].instance()
		var canvas_layer = CanvasLayer.new()
		canvas_layer.set_layer(event.priority)
		canvas_layer.add_child(event)
		current_events[event_name] = event

		$"/root/stage".add_child(canvas_layer)

		if params == null:
			event.start()
		else:
			event.start(params)
		return event
	return null


func stop(event_name):
	if current_events.has(event_name):
		var event = current_events[event_name]
		current_events.erase(event_name)

		var canvas_layer = event.get_parent()
		event.stop()
		yield(event, "tree_exited")
		canvas_layer.queue_free()

		# animation is finished
		$"/root".set_disable_input(false)


func stop_closeables():
	for event_name in current_events.keys():
		var event = current_events[event_name]
		if event.back_button:
			stop(event_name)


func closeable_event():
	for event in current_events.values():
		if event.back_button:
			return true
	return false


func _on_broccoli_duck_timer_timeout():
	start("broccoli_duck")

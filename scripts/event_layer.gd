extends Node2D


var duck_ready = true

var current_events = {}
onready var event_scene_dict = {
	"broccoli": preload("res://scenes/events/broccoli_selection.tscn"),
	"broccoli_duck": preload("res://scenes/events/broccoli_duck.tscn"),
	"wait_for_rewarded_ad": preload("res://scenes/events/wait_for_rewarded_ad.tscn"),
	"win": preload("res://scenes/events/win.tscn"),
	"tutorial": preload("res://scenes/events/tutorial.tscn"),
	"roulette": preload("res://scenes/events/roulette.tscn"),
	"broccolitron": preload("res://scenes/events/broccolitron.tscn")
}


func _ready():
	$broccoli_duck_timer.start()


func start(event_name, params=null):
	if not event_name in current_events:
		var event = event_scene_dict[event_name].instance()
		var canvas_layer = CanvasLayer.new()
		canvas_layer.set_layer(event.priority)
		canvas_layer.add_child(event)
		current_events[event_name] = event

		$"/root/stage".add_child(canvas_layer)
		event.rescale(game.resizer.s)
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
	if game.board_layer.movements >= 53 and duck_ready and not game.win:
		start("broccoli_duck")
		duck_ready = false
		game.board_layer.movements = 0
		$"duck_ready".start()


func get_or_start(event_name):
	if current_events.has(event_name):
		return current_events[event_name]
	else:
		return start(event_name)


func _on_duck_ready_timeout():
	duck_ready = true

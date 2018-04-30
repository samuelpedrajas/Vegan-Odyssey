extends Node2D


onready var broccoli_girl = $broccoli_girl

enum SCENARIO {
	no_events,
	broccoli_selection_event
}


var sequence = {
	1: {
		"anim": {
			SCENARIO.no_events: "hidden",
			SCENARIO.broccoli_selection_event: "hidden"
		},
		"time": 3
	},
	2: {
		"anim": {
			SCENARIO.no_events: "hello",
			SCENARIO.broccoli_selection_event: "hidden"
		},
		"time": 4
	},
	3: {
		"anim": {
			SCENARIO.no_events: "angry",
			SCENARIO.broccoli_selection_event: "hidden"
		},
		"time": 4
	},
	4: {
		"anim": {
			SCENARIO.no_events: "hidden",
			SCENARIO.broccoli_selection_event: "hidden"
		},
		"time": 0.5
	},
}


var priority = 5
var closeable = false

var step = 0
var broccoli_selection = false setget on_broccoli_selection


func start():
	# move girl to board layer
	remove_child(broccoli_girl)
	game.board_layer.add_child(broccoli_girl)

	broccoli_selection = "broccoli" in game.event_layer.current_events.keys()

	# start first animation
	next_step()


func stop():
	broccoli_girl.queue_free()
	queue_free()


func _on_click_area_gui_input(event):
	if event.is_action_pressed("click"):
		game.popup_layer.open("reset_board_confirmation")


func _on_timer_timeout():
	if step < sequence.size():
		next_step()
	else:
		game.event_layer.stop("broccoli_girl")


func next_step():
	step += 1
	play_animation()

	# get info from the structure
	var t = sequence[step].time

	$timer.set_wait_time(t)
	$timer.start()


func play_animation():
	# select animation
	var step_info = sequence[step]
	var anim = step_info.anim[SCENARIO.no_events]
	if broccoli_selection:
		anim = step_info.anim[SCENARIO.broccoli_selection_event]
	broccoli_girl.play(anim)


func on_broccoli_selection(v):
	broccoli_selection = v
	play_animation()

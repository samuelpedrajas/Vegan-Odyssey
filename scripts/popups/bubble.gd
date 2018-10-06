extends Control

onready var label = $label

enum { LEFT, RIGHT, NONE }

var text
var tail = NONE setget set_tail

var actions
var girl

var stops_dict = {
	".": 10,
	":": 10,
	"?": 10,
	"!": 10
}

var threshold = 20
var x_threshold = 75

var prev_bubble

var current_c = -1

var skip_timers = 0


signal finished
signal start_action


var acc_time = 0.00
var container_anim_time = 0.1

var container_dest
var container_start

var first_actions = []
var lucy_last_action = null
var lau_last_action = null
var space_positions = []


func _process(delta):
	if container_dest == null:
		return
	acc_time += delta
	var next_pos = container_start.linear_interpolate(
		container_dest, acc_time / container_anim_time
	)
	if next_pos.y < container_dest.y:
		get_parent().reposition_msgs(game.resizer.s)
		set_process(false)
		$animation.play("open")
	else:
		get_parent().set_position(next_pos)


func play():
	set_process(true)


func _build_dict(line):
	actions = {}
	text = ""
	girl = line[0]

	var first_action_counter = 2
	var dt = line[1]
	var i = 0
	var j = 0
	while i < dt.length():
		var c = dt[i]
		if c == '(':
			var end = dt.find(")", i)
			var action_name = dt.substr(i + 1, end - (i + 1))
			if actions.has(j):
				actions[j].append(action_name)
			else:
				actions[j] = [action_name]
			i += action_name.length() + 2

			if action_name.substr(0, 3) == "lau":
				lau_last_action = action_name
			else:
				lucy_last_action = action_name

			if prev_bubble == null and first_action_counter > 0:
				first_actions = actions[j]
				first_action_counter -= 1
		else:
			text += c
			i += 1
			if c != " ":
				j += 1


func remove_me():
	hide()
	queue_free()


func build_space_positions():
	var counter = 1
	for i in range(text.length()):
		var c = text[i]
		if c == " ":
			space_positions.append(i - counter)
			counter += 1


func setup(screen, _prev_bubble, line):
	set_process(false)
	prev_bubble = _prev_bubble

	connect("finished", screen, "bubble_finished")
	connect("start_action", screen, "start_action")
	_build_dict(line)

	label.set_text(text)
	_next_char()

	build_space_positions()
	text = text.replace(" ", "")

	# if just 1 line, center the text
	if label.get_line_count() < 2:
		label.set_align(Label.ALIGN_CENTER)
	else:
		label.set_align(Label.ALIGN_LEFT)

	# set proper height
	var height = label.get_line_count() * label.get_line_height() + 30
	set_size(Vector2(get_size().x, height))

	var _x_threshold = x_threshold
	var dest_distance =  Vector2(0, get_size().y + threshold) * game.resizer.s

	# move msgs up
	container_start = get_parent().get_position()
	container_dest = get_parent().get_position() - dest_distance

	# if it's not the first one, set the proper "y" position
	if prev_bubble != null:
		prev_bubble.tail = NONE
		set_position(Vector2(
			0,
			prev_bubble.get_position().y + prev_bubble.get_size().y + threshold
		))

	# set "x" position according to the girl
	if girl == "B":
		self.tail = RIGHT
		set_position(
			get_position() + Vector2(
				get_parent().get_size().x - get_size().x - _x_threshold,
				0
			)
		)
	else:
		self.tail = LEFT
		set_position(
			get_position() + Vector2(_x_threshold, 0)
		)


func set_tail(v):
	$tail_left.hide()
	$tail_right.hide()
	if v == LEFT:
		$tail_left.show()
	elif v == RIGHT:
		$tail_right.show()


func _next_char():
	current_c += 1
	if actions.has(current_c):
		for action in actions[current_c]:
			emit_signal("start_action", action)
	$label.set_visible_characters(current_c)


func _on_timer_timeout():
	if current_c >= text.length():
		finish_it()
	elif skip_timers > 0:
		skip_timers -= 1
	elif stops_dict.has(text[current_c]) and current_c in space_positions:
		skip_timers = stops_dict[text[current_c]]
		_next_char()
	else:
		_next_char()


func finish_it():
	$timer.stop()
	set_process(false)
	$label.set_visible_characters(-1)
	emit_signal("finished")


func _on_animation_animation_finished(anim_name):
	$"/root".set_disable_input(false)
	$timer.start()

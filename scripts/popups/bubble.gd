extends Control

onready var label = $label

var text
enum TAIL { LEFT, RIGHT, NONE }
var tail = TAIL.NONE setget set_tail

var actions
var girl

var animate
var threshold = 20

var prev_bubble

signal finished

func _ready():
	label.set_text(text)
	if label.get_line_count() < 2:
		label.set_align(Label.ALIGN_CENTER)
	else:
		label.set_align(Label.ALIGN_FILL)

	var height = label.get_line_count() * label.get_line_height() + 30
	set_size(Vector2(get_size().x, height))
	get_parent().set_position(
		get_parent().get_position() - Vector2(0, height + threshold)
	)

	if prev_bubble != null:
		prev_bubble.tail = TAIL.NONE
		set_position(Vector2(
			0,
			prev_bubble.get_position().y + prev_bubble.get_size().y + threshold
		))

	if girl == "B":
		self.tail = TAIL.RIGHT
		set_position(
			get_position() + Vector2(
				get_parent().get_size().x - get_size().x - 75,
				0
			)
		)
	else:
		self.tail = TAIL.LEFT
		set_position(
			get_position() + Vector2(75, 0)
		)

	if animate:
		$animation.play("open")
		yield($animation, "animation_finished")

	emit_signal("finished")


func setup(screen, _prev_bubble, line, _animate):
	animate = _animate
	prev_bubble = _prev_bubble

	connect("finished", screen, "bubble_finished")
	actions = {}
	text = ""
	girl = line[0]

	var dt = line[1]
	var i = 0
	var j = 0
	while i < dt.length():
		var c = dt[i]
		if c == '(':
			var end = dt.find(")", i)
			var action_name = dt.substr(i + 1, end - (i + 1))
			actions[j] = action_name
			i += action_name.length() + 2
		else:
			text += c
			i += 1
			j += 1


func set_tail(v):
	$tail_left.hide()
	$tail_right.hide()
	if v == LEFT:
		$tail_left.show()
	elif v == RIGHT:
		$tail_right.show()

extends Control

onready var label = $label

var text setget set_text
enum TAIL { LEFT, RIGHT, NONE }
var tail = TAIL.NONE setget set_tail

func _ready():
	label.set_text(str(text))
	if label.get_line_count() < 2:
		label.set_align(Label.ALIGN_CENTER)
	else:
		label.set_align(Label.ALIGN_FILL)
	set_size(
		Vector2(get_size().x,
		label.get_line_count() * label.get_line_height() + 30)
	)


func set_text(v):
	if v == null:
		return
	text = v


func set_tail(v):
	$tail_left.hide()
	$tail_right.hide()
	if v == LEFT:
		$tail_left.show()
	elif v == RIGHT:
		$tail_right.show()

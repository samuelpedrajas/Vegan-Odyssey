tool
extends Control

export(String) var text setget set_text
enum TAIL { LEFT, RIGHT, NONE }
export(TAIL) var tail = tail.none setget set_tail



func set_text(v):
	if v == null:
		return
	text = v
	$label.set_text(v)
	if $label.get_line_count() < 2:
		$label.set_align(Label.ALIGN_CENTER)
	else:
		$label.set_align(Label.ALIGN_FILL)
	set_size(
		Vector2(get_size().x, $label.get_size().y + 10)
	)


func set_tail(v):
	$tail_left.hide()
	$tail_right.hide()
	if v == LEFT:
		$tail_left.show()
	elif v == RIGHT:
		$tail_right.show()

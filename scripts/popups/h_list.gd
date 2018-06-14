extends Node2D

var subpopup = preload("res://scenes/popups/excuse_subpopup.tscn")

var init_excuse
var actual_excuse
var popups = {}

var starting_position
var accumulated_time = 0.0
var anim_time = 0.2


var dest

var blocked = true


func setup(excuse_number):
	init_excuse = excuse_number
	actual_excuse = excuse_number
	dest = Vector2(0, 0)
	starting_position = position

	for i in range(-1, 2):
		var popup = subpopup.instance()
		var n = fposmod(excuse_number + i - 1, 9) + 1
		popup.setup(n, (n - init_excuse) * Vector2(1080, 0))
		popups[n] = popup

		if n != excuse_number:
			popup.hide()
		add_child(popup)


func show_all():
	for popup in popups.values():
		popup.show()


func goto(n):
	if not blocked:
		return

	starting_position = position
	accumulated_time = 0.0
	blocked = false

	var direction = (n - actual_excuse)
	if actual_excuse + direction < 1 or actual_excuse + direction > 9:
		return

	var from_idx = fposmod(actual_excuse - direction - 1, 9) + 1
	var to_idx = fposmod(n + direction - 1, 9) + 1
	dest = (fposmod(n - 1, 9) - init_excuse + 1) * Vector2(-1080, 0)
	actual_excuse = fposmod(n - 1, 9) + 1

	var popup = popups[from_idx]
	popups.erase(from_idx)
	popups[to_idx] = popup
	popup.setup(to_idx, (to_idx - init_excuse) * Vector2(1080, 0))


func goto_next():
	goto(actual_excuse + 1)


func goto_prev():
	goto(actual_excuse - 1)


func swift(first, second):
	var d =  second - first
	position.x = (position.x + dest.x + d.x) / 2
	starting_position = position


func check_change():
	var distance = starting_position.x - dest.x
	if distance > 120:
		goto_prev()
	elif distance < -120:
		goto_next()


func _process(delta):
	if blocked:
		return

	accumulated_time += delta
	if abs(position.x - dest.x) < 1:
		position = dest
		accumulated_time = 0.0
		blocked = true
	else:
		position = starting_position.linear_interpolate(dest, min(1.0, accumulated_time / anim_time))

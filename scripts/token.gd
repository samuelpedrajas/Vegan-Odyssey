extends Node2D


var matrix_pos
var destination

onready var animation = $animation

var level

var is_selectable = false
var is_moving = false
var is_dying = false

var speed = Vector2(5, 10)
var angular_speed = 5

var followed = null
var followers = []

# movement purposes
var accumulated_time = 0
var starting_position = null


signal movement_finished
signal token_selected


func setup(wp, pos, lvl, sc):
	matrix_pos = pos
	level = lvl
	position = wp
	destination = wp
	set_scale(sc)

	var texture = game.lang.EXCUSES[level - 1]["token_sprite"]
	$"token_sprite".set_texture(texture)
	$"token_sprite/level".set_text(str(level))


func _process(delta):
	if is_moving:
		var moved = _move(delta)
		if not moved:
			is_moving = false
			set_process(false)
			position = destination
			if followed != null:
				_merge_and_free()
			elif is_stopped():
				emit_signal("movement_finished")
	elif is_dying:
		var gravity = Vector2(0, 5000)  # px / s^2
		speed += gravity * delta
		position += speed * delta
		rotation = rotation + (angular_speed * delta)
		if modulate.a > 0:
			modulate.a = max(0, modulate.a - delta / modulate.a)
		else:
			set_process(false)
			queue_free()


func _move(delta):
	accumulated_time += delta
	if accumulated_time >= game.cfg.ANIMATION_TIME:
		position = destination
		return false
	position = starting_position.linear_interpolate(destination, accumulated_time / game.cfg.ANIMATION_TIME)
	return true


func _merge_and_free():
	hide()
	followed.followers.erase(self)
	# transfer all followers to the actual followed
	for follower in followers:
		follower.takeover(followed)

	followed.animation.play("merge")

	if followed.is_stopped():
		followed.emit_signal("movement_finished")

	print("I'm " + str(get_instance_id()) + " - bye bye!")
	queue_free()


func takeover(new_followed):
	followed = new_followed
	followed.followers.append(self)
	destination = followed.destination


func is_stopped():
	return not is_moving and followers.empty()


func follow(token):
	followed = token
	followed.followers.append(self)

	set_z_index(followed.get_z_index() + 1)
	accumulated_time = 0
	is_moving = true
	destination = followed.destination
	starting_position = position


func move_to(dest):
	accumulated_time = 0
	matrix_pos = dest
	is_moving = true
	destination = get_parent().get_parent().tilemap.map_to_world(dest)
	starting_position = position


func _get_angular_speed(direction):
	var x = direction.x
	var y = direction.y
	var ang_speed = 0
	if (x > y) != ((x + y) > 0):
		ang_speed = x * pow(-1, int(y > 0))
	else:
		ang_speed = y * pow(-1, int(x < 0))
	ang_speed = ang_speed / ($"token_sprite/button".get_size().x / 2.0)
	return pow(ang_speed, 3) * 10


func die(direction):
	get_parent().remove_child(self)
	game.dying_tokens.get_node("tokens").add_child(self)
	angular_speed = _get_angular_speed(direction)
	is_dying = true
	speed *= (direction * -1)
	game.sounds.play_audio("boom")
	set_process(true)


func set_selectable_state():
	print("SET " + str(get_instance_id()))
	# I assume the token is stopped here
	is_selectable = true
	animation.play("broccoli_selection")
	$"token_sprite/button".show()


func unset_selectable_state():
	print("UNSET " + str(get_instance_id()))
	if is_selectable:
		is_selectable = false
		animation.stop()
		$"token_sprite/glow".hide()
		$"token_sprite/button".hide()


func sync_merge():
	var texture = game.lang.EXCUSES[level - 1]["token_sprite"]
	$"token_sprite".set_texture(texture)
	$"token_sprite/level".set_text(str(level))
	game.sounds.play_audio("merge")


func save_info():
	return {
		"pos.x": matrix_pos.x,
		"pos.y": matrix_pos.y,
		"level": level
	}


func _on_button_gui_input(ev):
	if not ev.is_action_pressed("click") or ev.position == null:
		return

	if is_selectable and game.broccolis > 0:
		var total_area = $"token_sprite/button".get_size()
		var direction = (ev.position - total_area / 2)
		print(direction)
		unset_selectable_state()
		emit_signal("token_selected", self, direction)

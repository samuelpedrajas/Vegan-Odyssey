extends Node2D


var matrix_pos
var destination

onready var animation = $animation

var level

var is_selectable = false
var is_moving = false
var followed = null
var followers = []

# movement purposes
var accumulated_time = 0
var starting_position = null


func _ready():
	set_process(false)
	$timer.set_wait_time(cfg.SPAWN_ANIMATION_TIME)


func setup(wp, pos, lvl, sc):
	matrix_pos = pos
	level = lvl
	position = wp
	destination = wp
	set_scale(sc)

	var texture = cfg.EXCUSES[level - 1]["token_sprite"]
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


func _move(delta):
	accumulated_time += delta
	if accumulated_time >= cfg.ANIMATION_TIME:
		position = destination
		return false
	position = starting_position.linear_interpolate(destination, accumulated_time / cfg.ANIMATION_TIME)
	return true


func _merge_and_free():
	hide()
	followed.followers.erase(self)
	for follower in followers:
		follower.takeover(followed)
	followed.animation.play("merge")
	yield(followed.animation, "animation_finished")
	print("I'm " + str(get_instance_id()) + " - bye bye!")
	queue_free()


func takeover(new_followed):
	followed = new_followed
	followed.followers.append(self)
	destination = followed.destination


func follow(token):
	followed = token
	followed.followers.append(self)

	accumulated_time = 0
	is_moving = true
	destination = followed.destination
	starting_position = position


func move_to(dest):
	accumulated_time = 0
	matrix_pos = dest
	is_moving = true
	destination = $"../../tilemap".map_to_world(dest)
	starting_position = position


func die():
	print("Token " + str(get_instance_id()) + " is dying...")
	# wait until all other animations are done
	if is_moving:
		yield(self, "token_animation_finished")

	# finish it
	animation.play("die")
	yield(animation, "animation_finished")
	queue_free()


func delayed_spawn():
	$timer.start()
	yield($timer, "timeout")
	animation.play("spawn")


func set_selectable_state():
	# I assume the token is stopped here
	is_selectable = true
	animation.play("broccoli_selection")
	$"button".show()


func unset_selectable_state():
	is_selectable = false
	animation.stop()
	$"glow".hide()
	$"button".hide()


func sync_merge():
	var texture = cfg.EXCUSES[level - 1]["token_sprite"]
	$"token_sprite".set_texture(texture)
	$"token_sprite/level".set_text(str(level))
	game.sounds.play_audio("merge")


func save_info():
	return {
		"pos.x": matrix_pos.x,
		"pos.y": matrix_pos.y,
		"level": level
	}


func _on_button_pressed():
	if is_selectable and game.broccolis > 0:
		game.use_broccoli(self)

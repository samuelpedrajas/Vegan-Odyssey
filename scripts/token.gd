extends Node2D


var matrix_pos
var world_pos

onready var animation = $"animation"

var level
var tween

var is_selectable = false
var is_dying = false

func setup(wp, pos, t, lvl):
	matrix_pos = pos
	level = lvl
	tween = t
	world_pos = wp
	update(false)


func set_selectable_state():
	is_selectable = true
	animation.play("broccoli_selection")
	$"button".show()


func unset_selectable_state():
	is_selectable = false
	animation.stop()
	$"glow".hide()
	$"button".hide()


func move_to(wp):
	world_pos = wp
	# interpolate the position
	var animation_time = (world_pos - get_position()).length() / cfg.ANIMATION_SPEED
	tween.interpolate_method(
		self, "set_position", get_position(), world_pos,
		animation_time, tween.TRANS_QUAD, tween.EASE_OUT
	)
	# decrease opacity for a smoother animation
	modulate.a = cfg.MOVEMENT_OPACITY
	tween.interpolate_callback(self, animation_time, "update")

	return animation_time


func update(scale=true):
	var token_sprite = $"token_sprite"
	var level_label = $"token_sprite/level"
	var texture = cfg.EXCUSES[level - 1]["token_sprite"]
	token_sprite.set_texture(texture)
	level_label.set_text(str(level))
	set_position(world_pos)
	modulate.a = 1
	if scale:
		set_scale(Vector2(1, 1))
	# if it was marked as dying -> kill it
	if is_dying:
		die(false)


func die(animate=true):
	tween.remove(self, 'position')
	if animate:
		animation.play_backwards("spawn")
		yield(animation, "animation_finished")
	print("Token " + str(get_instance_id()) + " is dying...")
	queue_free()


func merge():
	update()
	animation.play("merge")
	game.sounds.play_audio("merge")


func save_info():
	return {
		"pos.x": matrix_pos.x,
		"pos.y": matrix_pos.y,
		"level": level
	}


func _on_button_pressed():
	print("TOCA")
	if is_selectable and game.broccolis > 0:
		game.use_broccoli(self)

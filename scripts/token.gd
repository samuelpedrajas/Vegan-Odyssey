extends Node2D


# for broccolis (send the matrix position)
var matrix_pos

onready var animation = $"animation"

var level
var tween

var is_selectable = false
var is_dying = false

func setup(world_pos, pos, t, lvl):
	matrix_pos = pos
	level = lvl
	tween = t
	set_content()
	set_position(world_pos)


func die(animate=true):
	tween.remove(self, 'position')
	if animate:
		animation.play_backwards("spawn")
		yield(animation, "animation_finished")
	print("Token " + str(get_instance_id()) + " is dying...")
	queue_free()


func set_selectable_state():
	is_selectable = true
	animation.play("broccoli_selection")
	$"button".show()


func unset_selectable_state():
	is_selectable = false
	animation.stop()
	$"glow".hide()
	$"button".hide()


func move_to(world_pos):
	# interpolate the position
	var animation_time = (world_pos - get_position()).length() / cfg.ANIMATION_SPEED
	tween.interpolate_method(
		self, "set_position", get_position(), world_pos,
		animation_time, tween.TRANS_QUAD, tween.EASE_OUT
	)
	# decrease opacity for a smoother animation
	modulate.a = cfg.MOVEMENT_OPACITY
	tween.interpolate_callback(self, animation_time, "update_state", world_pos)

	return animation_time


func update_state(world_pos):
	print("[" + str(get_instance_id()) + "]: Updating state...")
	# set pos just in case the tweening failed
	set_position(world_pos)
	modulate.a = 1

	# if it was marked as dying -> kill it
	if is_dying:
		die(false)


func merge():
	set_content()
	animation.play("merge")
	game.sounds.play_audio("merge")


func set_content():
	var token_sprite = get_node("token_sprite")
	var level_label = get_node("token_sprite/level")
	var texture = cfg.EXCUSES[level - 1]["token_sprite"]
	token_sprite.set_texture(texture)
	level_label.set_text(str(level))


func _on_button_pressed():
	print("TOCA")
	if is_selectable and game.broccolis > 0:
		game.use_broccoli(self)

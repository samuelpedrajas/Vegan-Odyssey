extends Node2D


# for broccolis (send the matrix position)
var matrix_pos

onready var animation = $"animation"

var level
var token_to_merge_with = null
var tween

var is_selectable = false


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


func is_merging():
	return token_to_merge_with


func define_tweening(world_pos):
	# interpolate the position
	tween.interpolate_method(
		self, "set_position", get_position(), world_pos,
		cfg.ANIMATION_TIME, tween.TRANS_LINEAR, tween.EASE_IN
	)
	# decrease opacity for a smoother animation
	modulate.a = cfg.MOVEMENT_OPACITY


func update_state(world_pos):
	# set pos just in case the tweening failed
	set_position(world_pos)
	modulate.a = 1

	# if it's flagged as merge -> merge it
	if token_to_merge_with:
		token_to_merge_with.set_content()
		token_to_merge_with.animation.play("merge")
		die(false)


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

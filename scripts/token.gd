extends Node2D


onready var animation = get_node("animation")
var level
var token_to_merge_with = null
var current_pos
var tween

var is_selectable = false
var is_dying = false


func setup(pos, t, lvl):
	level = lvl
	tween = t
	current_pos = pos
	_set_content()
	set_position(_get_world_position(pos))  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	animation.play("spawn")


func die():
	is_dying = true
	get_node("broccoli_spawn").set_active(false)
	animation.play_backwards("spawn")


func set_selectable_state():
	is_selectable = true
	animation.play("broccoli_selection")
	get_node("button").show()


func unset_selectable_state():
	is_selectable = false
	animation.stop()
	get_node("broccoli_spawn").set_active(false)
	get_node("glow").hide()
	get_node("button").hide()


func is_merging():
	return token_to_merge_with


func define_tweening():
	# get the real world position since destination is a position in the matrix
	var world_pos = _get_world_position(current_pos)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

	# interpolate the position
	tween.interpolate_method(
		self, "set_position", get_position(), world_pos,  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		cfg.ANIMATION_TIME, tween.TRANS_LINEAR, tween.EASE_IN
	)
	# decrease opacity for a smoother animation
	modulate.a = cfg.MOVEMENT_OPACITY  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review


func update_state():
	# set pos just in case the tweening failed
	set_position(_get_world_position(current_pos))  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	modulate.a = 1  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

	# if it's flagged as merge -> merge it
	if token_to_merge_with:
		token_to_merge_with.increase_value()
		token_to_merge_with = null
		tween.remove(self, 'position')  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		hide()
		queue_free()
		return


func increase_value():
	level += 1
	_set_content()
	# play merge animation
	get_node("animation").play("merge")


func _set_content():
	var token_sprite = get_node("token_sprite")
	var level_label = get_node("token_sprite/level")
	var texture = get_parent().get_token_content(level)
	token_sprite.set_texture(texture)
	level_label.set_text(str(level))


func _get_world_position(pos):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	var offset = Vector2(336 / 2, 334 / 2)
	return get_parent().map_to_world(current_pos) + offset


func _on_animation_finished(anim_name):
	if is_dying:
		queue_free()


func _on_button_pressed():
	print("TOCA")
	if is_selectable and g.game.broccolis > 0:
		g.game.use_broccoli(self)


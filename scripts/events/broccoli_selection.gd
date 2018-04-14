extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func start():
	var n = g.game.get_node("event_layer").get_layer()
	g.game.get_node("board_layer").set_layer(n + 1)

	animation.play("open")
	yield(animation, "animation_finished")

	# set selectable state for all tokens
	for token in get_tree().get_nodes_in_group("token"):
		token.set_selectable_state()


func stop():
	g.game.get_node("board_layer").set_layer(0)
	animation.play_backwards("open")
	yield(animation, "animation_finished")

	# unset selectable state for all tokens
	for token in get_tree().get_nodes_in_group("token"):
		token.unset_selectable_state()
	queue_free()


func _on_clickabe_area_pressed():
	g.stop_event()

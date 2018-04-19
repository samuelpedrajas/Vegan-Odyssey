extends Node2D


onready var animation = $"animation"


func start():
	var n = game.event_layer.get_layer()
	game.board_layer.set_layer(n + 1)

	animation.play("open")
	yield(animation, "animation_finished")

	# set selectable state for all tokens
	for token in get_tree().get_nodes_in_group("token"):
		token.set_selectable_state()


func stop():
	animation.play_backwards("open")
	yield(animation, "animation_finished")
	game.board_layer.set_layer(0)

	# unset selectable state for all tokens
	for token in get_tree().get_nodes_in_group("token"):
		token.unset_selectable_state()
	queue_free()


func _on_clickabe_area_pressed():
	game.event_layer.stop()

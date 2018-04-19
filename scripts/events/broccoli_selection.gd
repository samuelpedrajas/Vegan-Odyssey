extends Node2D


onready var animation = $"animation"
var board_original_layer = 1


func start():
	board_original_layer = game.board_layer.get_layer()
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
	game.board_layer.set_layer(board_original_layer)

	# unset selectable state for all tokens
	for token in get_tree().get_nodes_in_group("token"):
		token.unset_selectable_state()
	queue_free()


func _on_clickabe_area_pressed():
	game.event_layer.stop()

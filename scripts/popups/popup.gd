extends Node2D


onready var animation = $"animation"


func close(anim="close_window"):
	animation.play("close_window")
	yield(animation, "animation_finished")
	queue_free()


func open(anim="open_window"):
	animation.play(anim)

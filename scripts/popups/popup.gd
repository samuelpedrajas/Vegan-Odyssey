extends Node2D


onready var animation = $"animation"


func close():
	animation.play("close_window")
	yield(animation, "animation_finished")
	queue_free()


func open():
	animation.play("open_window")

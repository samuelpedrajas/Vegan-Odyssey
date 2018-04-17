extends Node2D


onready var animation = get_node("animation")


func close():
	animation.play("close")
	yield(animation, "animation_finished")
	queue_free()


func open():
	animation.play("open")

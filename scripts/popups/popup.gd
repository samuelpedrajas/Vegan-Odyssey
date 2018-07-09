extends Control


onready var animation = $"animation"


func close(anim="close_window"):
	animation.play(anim)
	yield(animation, "animation_finished")
	queue_free()


func open(anim="open_window"):
	animation.play(anim)

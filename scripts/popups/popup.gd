extends Control


onready var animation = $"animation"

var open_anim = "open_window"
var close_anim = "close_window"


func close():
	animation.play(close_anim)
	yield(animation, "animation_finished")
	queue_free()


func open():
	animation.play(open_anim)

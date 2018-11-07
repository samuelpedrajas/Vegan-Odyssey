extends Control

var current_number = 1

func start():
	$anim.play("roll")


func stop():
	$anim.stop()
	return current_number


func set_one():
	current_number = 1


func set_two():
	current_number = 2


func set_three():
	current_number = 3

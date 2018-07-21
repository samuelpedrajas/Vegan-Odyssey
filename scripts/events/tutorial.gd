extends Control


var post_scene = preload("res://scenes/other/tutorial_post.tscn")
var post = null


var priority = 5
var back_button = false


func start():
	pass


func post(n):
	if post != null:
		remove_child(post)
		post.queue_free()
	if n == "4":
		game.seen_tutorial[str(int(n) - 1)] = true
	else:
		game.seen_tutorial[n] = true
	post = post_scene.instance()
	post.set_post(n)
	add_child(post)
	post.animation.play("appear")


func unpost():
	if post != null:
		post.animation.play_backwards("appear")
		yield(post.animation, "animation_finished")
		remove_child(post)
		post.queue_free()
		post = null
		var msg1 = game.seen_tutorial["1"]
		var msg2 = game.seen_tutorial["2"]
		var msg3 = game.seen_tutorial["3"]
		if msg1 and msg2 and msg3:
			game.event_layer.stop("tutorial")


func stop():
	if post != null:
		post.animation.play_backwards("appear")
		yield(post.animation, "animation_finished")
		remove_child(post)
		post.queue_free()
		post = null
	queue_free()

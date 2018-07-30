extends Control


var post_scene = preload("res://scenes/other/tutorial_post.tscn")
var post = null


var priority = 5
var back_button = false

var black_bg = null


func start():
	black_bg = $black_bg
	remove_child(black_bg)
	$"/root/stage".add_child(black_bg)


func post(n):
	if post != null:
		unpost()
	if n == "4":
		game.seen_tutorial[str(int(n) - 1)] = true
	else:
		black_bg.show_bg(n)
		game.seen_tutorial[n] = true
	post = post_scene.instance()
	post.set_post(n)
	$post.add_child(post)
	post.animation.play("appear")


func check_finished():
	var msg1 = game.seen_tutorial["1"]
	var msg2 = game.seen_tutorial["2"]
	var msg3 = game.seen_tutorial["3"]
	return msg1 and msg2 and msg3


func unpost():
	if post != null:
		var n = post.n_string
		post.close()
		post = null

		black_bg.unpost(n)

		if check_finished():
			$timer.start()
			yield($timer, "timeout")
			game.event_layer.stop("tutorial")


func stop():
	black_bg.queue_free()
	queue_free()


func _on_clickable_area_gui_input(ev):
	if ev.is_action_pressed("click"):
		unpost()

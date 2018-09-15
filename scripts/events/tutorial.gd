extends Control


var post_scene = preload("res://scenes/other/tutorial_post.tscn")
var post = null


var priority = 5
var back_button = false

var black_bg = null


func start():
	black_bg = $"/root/stage/hud_layer/hud/lower_buttons/black_bg"
	black_bg.connect("unpost_tutorial", self, "unpost")


func post(n):
	if post != null:
		unpost()
	if n == "4":
		game.seen_tutorial["3"] = true
		game.seen_tutorial["4"] = true
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
	var msg4 = game.seen_tutorial["4"]
	return msg1 and msg2 and msg3 and msg4


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
	black_bg.hide()
	queue_free()


func rescale(s):
	$post.set_scale(Vector2(s, s))

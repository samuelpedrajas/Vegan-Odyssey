extends Control


var priority = 9
var back_button = false


var roulette_ready = false


var speed = 2.0 * PI  # rotation per second
var acc_delta = 0.0


func _process(delta):
	acc_delta += delta

	if acc_delta > 1.0:
		acc_delta -= 1.0

	$roulette.set_rotation(acc_delta * speed)


func start():
	$anim.play("appear")


func stop():
	queue_free()


func _on_stop_pressed():
	if roulette_ready:
		game.event_layer.stop("roulette")


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":
		roulette_ready = true

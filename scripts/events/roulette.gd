extends Control

const e = 2.718282

var priority = 9
var back_button = false

var roulette_ready = false
var bouncing = false

var complete_round = 2.0 * PI
var speed = complete_round  # rotation per second
var bounce_amplitude = speed / 16.0
var acc_delta = 0.0

var bounce_offset = 0.0
var final_rot = 0.0
var final_rots = []


func _calculate_final_rots():
	var offset = complete_round / 16.0
	var acc = offset / 2.0
	for i in range(16):
		final_rots.append(acc)
		acc += offset


func _get_closest_rot(rot):
	var closest = null
	var closest_dist = complete_round
	for _final_rot in final_rots:
		var dist = abs(_final_rot - rot)
		if dist < closest_dist:
			closest_dist = dist
			closest = _final_rot
	final_rot = closest


func _process(delta):
	acc_delta += delta

	if not bouncing:
		if acc_delta > 1.0:
			acc_delta -= 1.0
		$roulette.set_rotation(acc_delta * speed)
	else:
		var mult = pow(e, -acc_delta * 2.0) * cos(complete_round * acc_delta * 2.0 + bounce_offset)
		var offset = mult * bounce_amplitude
		print(offset)
		$roulette.set_rotation(final_rot + offset)


func start():
	_calculate_final_rots()
	$anim.play("appear")


func stop():
	queue_free()


func _on_stop_pressed():
	print("ENTRANDO AQUI")
	if roulette_ready:
		print("Y AQUI")
		#game.sounds.play_audio("click")
		bouncing = true
		acc_delta = 0.0
		_calculate_final_rots()
		_get_closest_rot($roulette.get_rotation())
		bounce_offset = ($roulette.get_rotation() - final_rot) / complete_round
		#game.event_layer.stop("roulette")


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":
		roulette_ready = true
		$"/root".set_disable_input(false)

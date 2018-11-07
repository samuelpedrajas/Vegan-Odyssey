extends Control

const e = 2.718282

var priority = 9
var back_button = false

var still_rolling = true
var roulette_ready = false
var bouncing = false

var complete_round = 2.0 * PI
var speed = 1.8 * PI  # rotation per second
var bounce_amplitude = complete_round / 16.0
var acc_delta = (bounce_amplitude / 2.0) / speed
var arrow_amplitude = 20.0

var bounce_offset = 0.0
var final_rot = null
var final_rots = []

onready var roulette_texture = $roulette/roulette_texture
onready var arrow_texture = $roulette/arrow_texture


func _ready():
	_calculate_final_rots()


func _calculate_final_rots():
	var offset = complete_round / 16.0
	var acc = offset / 2.0
	for i in range(16):
		final_rots.append(acc)
		acc += offset

func _get_smallest_distance(target, source):
	var a = target - source
	return fmod(a + PI, complete_round) - PI


func _get_closest_rot(rot):
	var closest = null
	var closest_dist = complete_round

	for _final_rot in final_rots:
		var dist = abs(_get_smallest_distance(_final_rot, rot))
		if dist < closest_dist:
			closest_dist = dist
			closest = _final_rot

	return closest


func _update_arrow(rot, closest, amp):
	var new_rot = null
	var roll_offset = bounce_amplitude / 2.0
	var left_pole = closest - bounce_amplitude / 2.0
	var right_pole = closest + bounce_amplitude / 2.0
	if rot < closest:
		if rot > left_pole + roll_offset:
			new_rot = 0.0
		else:
			var mult = 1.0 - abs(_get_smallest_distance(rot, left_pole)) / roll_offset
			if mult > 1.8:
				print("FIRST: ", mult)
			new_rot = mult * amp
	else:
		if rot < right_pole - roll_offset:
			new_rot = 0.0
		else:
			var mult = abs(_get_smallest_distance(rot, right_pole - roll_offset)) / roll_offset
			if mult > 1.08:
				print("SECOND: ", mult)
			new_rot = mult * amp

	arrow_texture.set_rotation(
		arrow_texture.get_rotation() * 0.75 + new_rot * 0.25
	)


func _process(delta):
	var prev_rot = roulette_texture.get_rotation()

	acc_delta += delta

	if not bouncing:
		if acc_delta > complete_round / speed:
			acc_delta -= complete_round / speed
			prev_rot -= complete_round

		var rot = acc_delta * speed
		roulette_texture.set_rotation(rot)

		var closest = _get_closest_rot(rot)
		_update_arrow(rot, closest, _get_smallest_distance(prev_rot, rot) * arrow_amplitude)
	elif still_rolling:
		var rot = roulette_texture.get_rotation()
		if final_rot == null:
			acc_delta = 0.0
			final_rot = _get_closest_rot(rot)

		var mult = pow(e, -acc_delta * 2.0) * sin(complete_round * acc_delta * 2.0)
		var offset = mult * bounce_amplitude
		rot = final_rot - offset
		roulette_texture.set_rotation(rot)

		_update_arrow(rot, final_rot, _get_smallest_distance(prev_rot, rot) * arrow_amplitude)

		if acc_delta > 3.0:
			still_rolling = false
			set_process(false)


func start():
	_calculate_final_rots()
	$anim.play("appear")


func stop():
	queue_free()


func _on_stop_pressed():
	if roulette_ready:
		#game.sounds.play_audio("click")
		bouncing = true
		#game.event_layer.stop("roulette")


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":
		roulette_ready = true
		$"/root".set_disable_input(false)

extends Control

var priority = 6
var back_button = false

var broccolitron_ready = false

const e = 2.718282
var complete_round = 2.0 * PI


func _ready():
	randomize()


onready var broccolitron = [
	{
		"texture_rect": $broccolitron/big,
		"speed": 1.0 * PI, "started": false,
		"acc_delta": 0.0, "broccoli": null
	},
	{
		"texture_rect": $broccolitron/medium,
		"speed": -1.5 * PI, "started": false,
		"acc_delta": 0.0, "broccoli": null
	},
	{
		"texture_rect": $broccolitron/small,
		"speed": 2.0 * PI, "started": false,
		"acc_delta": 0.0, "broccoli": null
	}
]


var bounce_amplitude = complete_round / 6.0
var final_rots = [
	{ "rot": -complete_round, "broccoli": true },
	{ "rot": bounce_amplitude * -5.0, "broccoli": false },
	{ "rot": bounce_amplitude * -4.0, "broccoli": false },
	{ "rot": bounce_amplitude * -3.0, "broccoli": false },
	{ "rot": bounce_amplitude * -2.0, "broccoli": false },
	{ "rot": bounce_amplitude * -1.0, "broccoli": false },
	{ "rot": bounce_amplitude * 0.0, "broccoli": true },
	{ "rot": bounce_amplitude * 1.0, "broccoli": false },
	{ "rot": bounce_amplitude * 2.0, "broccoli": false },
	{ "rot": bounce_amplitude * 3.0, "broccoli": false },
	{ "rot": bounce_amplitude * 4.0, "broccoli": false },
	{ "rot": bounce_amplitude * 5.0, "broccoli": false },
	{ "rot": complete_round, "broccoli": true },
]


func _get_closest_rot(rot):
	var closest = null
	var closest_dist = complete_round

	for _final_rot in final_rots:
		var dist = abs(_final_rot.rot - rot)
		if dist < closest_dist:
			closest_dist = dist
			closest = _final_rot

	return closest


func _process(delta):
	for brocco in broccolitron:
		if brocco.started:
			brocco.acc_delta += delta

			if brocco.acc_delta > complete_round / brocco.speed:
				brocco.acc_delta = fmod(
					brocco.acc_delta, complete_round / brocco.speed
				)

			var rot = brocco.acc_delta * brocco.speed
			brocco.texture_rect.set_rotation(rot)


func start():
	game.sounds.play_minigame_music()
	game.go_back_manually_disabled = true
	$anim.play("appear")


func stop():
	$anim.play("disappear")


func get_shuffled(l):
	var aux_list = []
	for elem in l:
		aux_list.append(elem)

	var shuffled_list = []
	while not aux_list.empty():
		var i = randi() % len(aux_list)
		shuffled_list.append(aux_list[i])
		aux_list.remove(i)

	return shuffled_list


func set_speed(brocco):
	var m = 2.0 * PI * pow(-1, randi() % 2)
	var offset = 0.5 * PI * randf() * pow(-1, randi() % 2)
	brocco.speed = m + offset


func start_rolling():
	for brocco in broccolitron:
		set_speed(brocco)
		$timer.start()
		yield($timer, "timeout")
		game.sounds.play_audio("cling")
		brocco.started = true

	$timer.start()
	yield($timer, "timeout")
	broccolitron_ready = true
	$"/root".set_disable_input(false)
	$stop/anim.play("appear")
	broccolitron[1].texture_rect.get_node("anim").play("lock")
	broccolitron[2].texture_rect.get_node("anim").play("lock")


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":
		start_rolling()
	elif anim_name == "disappear":
		game.sounds.stop_minigame_music()
		queue_free()


var current_wheel = 0
var broccolis = 0

func _on_btn_pressed():
	if broccolitron_ready:
		$"/root".set_disable_input(true)
		$stop/btn.set_disabled(true)
		game.sounds.play_audio("slot_stop")

		var brocco = broccolitron[current_wheel]
		brocco.started = false
		var t = brocco.texture_rect
		var final_rot = _get_closest_rot(t.get_rotation())

		brocco.broccoli = final_rot.broccoli

		$tween.interpolate_method(
			t, "set_rotation", t.get_rotation(), final_rot.rot,
			0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0.0
		)
	
		$tween.start()
		current_wheel += 1


func rescale(s):
	var s2 = Vector2(s, s)
	$title.set_scale(s2)
	$broccolitron.set_scale(s2)
	$stop.set_scale(s2)


func finish_minigame():
	game.event_layer.stop("broccolitron")
	game.go_back_manually_disabled = false

	if broccolis > 0:
		if broccolis > 2:
			game.sounds.play_audio("lucky")
		game.secretly_set_broccolis(game.broccolis + broccolis)
		game.effects_layer.play_rewarded_effect(broccolis)
		if not game.board_layer.check_moves_available():
			game.hud_layer.glow_broccoli()
		game.save_game()
	else:
		game.sounds.play_audio("game_over")


func _on_tween_tween_completed(object, key):
	if broccolitron[current_wheel - 1].broccoli:
		broccolis += 1

	if current_wheel < 3:
		broccolitron[current_wheel].texture_rect.get_node("anim").play_backwards("lock")
		$"/root".set_disable_input(false)
		$stop/btn.set_disabled(false)
	else:
		finish_minigame()

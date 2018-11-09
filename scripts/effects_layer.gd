extends CanvasLayer

var plus1 = preload("res://scenes/other/plus1.tscn")


func _ready():
	set_process(false)


func play_rewarded_effect(n):
	var real_n = game.broccolis
	var shadow_broccolis = game.broccolis - n
	var timer = $"rewarded_animation/timer"
	var initial_delay = 0.5
	var broccoli_delay = 2.0 / 3.0

	timer.set_wait_time(broccoli_delay)
	for i in range(1, n + 1):
		emit_broccoli(broccoli_delay)

		timer.start()
		yield(timer, "timeout")

		print("Playing rewarded effect")
		if real_n == game.broccolis:
			game.hud_layer.set_broccoli_amount(shadow_broccolis + i)
		else:
			game.hud_layer.set_broccoli_amount(game.broccolis)

		var node = plus1.instance()
		$rewarded_animation/c.add_child(node)

		game.sounds.play_audio("bubble")
		set_process(true)


var anim_time = 0.2
var acc_time = 0.0
onready var broccoli_btn = $"/root/stage/hud_layer/hud/lower_buttons/broccoli"

func _process(delta):
	if acc_time >= anim_time:
		broccoli_btn.set_scale(Vector2(game.resizer.s, game.resizer.s))
		acc_time = 0.0
		set_process(false)
	elif acc_time < anim_time / 2.0:
		var s2 = Vector2(game.resizer.s, game.resizer.s)
		broccoli_btn.set_scale(
			s2 + s2 * 0.1 * (acc_time / (anim_time / 2.0))
		)
	else:
		var s2 = Vector2(game.resizer.s, game.resizer.s)
		broccoli_btn.set_scale(
			s2 * 1.1 - s2 * 0.1 * ((acc_time - anim_time / 2.0) / (anim_time / 2.0))
		)
	acc_time += delta


func set_loading():
	$"/root/stage/transition_layer/loading".set_loading()


func unset_loading():
	$"/root/stage/transition_layer/loading".unset_loading()


func play_new_record():
	$new_record.show()
	$new_record/anim.play("blinking")
	game.sounds.play_audio("new_record")


func stop_new_record():
	$new_record/anim.stop()
	$new_record.hide()


onready var source = $rewarded_animation/source
onready var source_timer = $rewarded_animation/source/timer

var broccoli_scene = preload("res://scenes/other/broccoli_unit.tscn")


func check_direction(p, line):
	return p.x * line.y - p.y * line.x > 0.0


func get_intensity(p, line):
	var mult = 1.0
	if check_direction(p, line):
		mult = -1.0
	return mult * (line.y * p.x - line.x * p.y) / line.length()


func emit_broccoli(t):
	var broccoli_btn = $"../hud_layer/hud/lower_buttons/broccoli"
	var dest = (
		broccoli_btn.get_position() - source.get_position() + broccoli_btn.get_size() / 2.0
	)
	var source_size = source.get_size()
	var source_pos = Vector2(
		fmod(randi(), source_size.x), fmod(randi(), source_size.y)
	)
	var broccoli = broccoli_scene.instance()
	var intensity = get_intensity(source_pos, source_size)
	source.add_child(broccoli)

	broccoli.start(source_pos, dest, intensity, t)

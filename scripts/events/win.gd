extends Control

var priority = 9
var back_button = false

var first_bang = false

var confetti_unit = preload("res://scenes/other/confetti_unit.tscn")
var num_units = 20
var freq = 0.8
var acc_time = 0.0

const region = 200

func _process(delta):
	acc_time += delta

	if acc_time < freq:
		return
	else:
		acc_time = 0.0

	var w = get_viewport().get_visible_rect().size.x
	for i in range(num_units):
		var sep = w / float(num_units)
		var pos = Vector2( i * sep, 0)
		var unit = confetti_unit.instance()
		unit.set_position(pos)

		var x_offset = randi() % int(region) - region / 2
		var y_offset = -randi() % int(region)
		unit.set_offset(Vector2(x_offset, y_offset))
		$confetti.add_child(unit)
		


func start():
	$animation.play("win")


func stop():
	queue_free()


func play_win_sound():
	game.sounds.play_audio("win")


func play_fireworks():
	game.sounds.play_audio("fireworks")
	if not first_bang:
		first_bang = true
	else:
		game.music.set_volume_db(cfg.MUSIC_VOLUME)


func rescale(s):
	for c in get_tree().get_nodes_in_group("confetti_unit"):
		c.queue_free()
		c.hide()

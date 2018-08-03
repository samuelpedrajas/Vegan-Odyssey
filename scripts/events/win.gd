extends Control

var priority = 9
var back_button = false

var new_volume_db = -20
var volume_db = null

var first_bang = false


func start():
	$animation.play("win")


func stop():
	queue_free()


func play_win_sound():
	volume_db = game.music.get_volume_db()
	game.music.set_volume_db(new_volume_db)
	
	game.sounds.play_audio("win")


func play_fireworks():
	game.sounds.play_audio("fireworks")
	if not first_bang:
		first_bang = true
		$confetti_cannon1.set_emitting(true)
	else:
		$confetti_cannon2.set_emitting(true)
		game.music.set_volume_db(volume_db)


func set_extents():
	var x_width = get_viewport().get_visible_rect().size.x
	var mat = $confetti_rain.get_process_material()
	mat.set_emission_box_extents(
		Vector3(
			x_width / 2,
			10,
			0
		)
	)

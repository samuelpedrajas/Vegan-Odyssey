extends HBoxContainer


var fake_token_scene = preload("res://scenes/other/fake_token.tscn")

onready var hole1 = $hole1
onready var hole2 = $hole2
onready var hole3 = $hole3
onready var tween = $tween


func _ready():
	start_collision_animation()


func start_merging_animation():
	var hole_size = hole1.get_size()
	var hole_w = hole_size.x
	var t1 = fake_token_scene.instance()
	var t2 = fake_token_scene.instance()

	hole1.add_child(t1)
	t1.set_position(t1.get_position() + hole_size / 2.0)
	hole3.add_child(t2)
	t2.set_position(t2.get_position() + hole_size / 2.0)

	tween.interpolate_method(
		t1, "set_position", t1.get_position(),
		t1.get_position() + Vector2(hole_w * 2.0, 0),
		0.2, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)

	yield(get_tree().create_timer(1.0), "timeout")
	tween.start()
	yield(tween, "tween_completed")
	t1.queue_free()
	t2.merge()
	yield(t2.animation, "animation_finished")

	yield(get_tree().create_timer(1.0), "timeout")

	t2.queue_free()
	start_merging_animation()


func start_collision_animation():
	var hole_size = hole1.get_size()
	var hole_w = hole_size.x
	var t1 = fake_token_scene.instance()
	var t2 = fake_token_scene.instance()
	t2.level_up()

	t1.set_position(hole1.get_position() + hole_size / 2.0)
	add_child(t1)
	t2.set_position(hole3.get_position())
	add_child(t2)

	tween.interpolate_method(
		t1, "set_position", t1.get_position(),
		t1.get_position() + Vector2(hole_w, 0),
		0.2, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)

	yield(get_tree().create_timer(1.0), "timeout")
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree().create_timer(1.0), "timeout")

	t1.queue_free()
	t2.queue_free()
	start_collision_animation()


func start_dying_animation():
	$hole1/fake_token.die()

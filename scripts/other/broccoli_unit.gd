extends Node2D


var anim_time
var curve
var dist

var particle_counter = 0
var n_particles = 20


var sparkle_scene = preload("res://scenes/other/sparkle.tscn")
var last_sparkle = null


onready var _container = $container
onready var _texture = $container/texture


func _ready():
	rescale(game.resizer.s)
	set_process(false)


var acc_delta = 0.0


func set_particle():
	if particle_counter > n_particles:
		return

	var tex_size = _texture.texture.get_size()
	var dest_x = randf() * tex_size.x
	var dest_y = randf() * tex_size.y
	var pos = _container.get_position()
	var sparkle = sparkle_scene.instance()
	sparkle.set_position(pos + Vector2(dest_x, dest_y))
	add_child(sparkle)
	last_sparkle = sparkle
	particle_counter += 1


func _process(delta):
	if anim_time / n_particles * particle_counter < acc_delta:
		set_particle()

	acc_delta += delta / anim_time

	if acc_delta > 1.0:
		set_process(false)
		_container.hide()
		if get_child_count() > 2:
			yield(last_sparkle, "tree_exited")
		print("Destroying broccoli missile")
		queue_free()
	else:
		_container.set_position(curve.interpolate(0, acc_delta))


func get_out_control(origin, dest, intensity):
	var d = dest - origin
	var offset = Vector2(-d.y, d.x).normalized() * intensity

	return (origin + d / 2.0) + offset


func start(origin, dest, intensity, anim_time):
	_container.set_position(origin)

	$anim.play("appear")

	var out_control = get_out_control(origin, dest, intensity)

	curve = Curve2D.new()
	curve.add_point(origin, origin, out_control, 0)
	curve.add_point(dest)

	dist = dest.x - origin.x
	self.anim_time = anim_time

	set_process(true)


func rescale(s):
	_container.set_scale(Vector2(s, s))

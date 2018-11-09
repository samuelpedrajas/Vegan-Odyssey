extends Sprite


var anim_time
var curve
var dist


func _ready():
	set_process(false)


var acc_delta = 0.0


func _process(delta):
	acc_delta += delta / anim_time

	if acc_delta > 1.0:
		set_process(false)
		print("Destroying broccoli missile")
		queue_free()
	else:
		set_position(curve.interpolate(0, acc_delta))


func get_out_control(origin, dest, intensity):
	var d = dest - origin
	var offset = Vector2(-d.y, d.x).normalized() * intensity

	return (origin + d / 2.0) + offset


func start(origin, dest, intensity, anim_time):
	set_position(origin)

	$anim.play("appear")

	var out_control = get_out_control(origin, dest, intensity)

	curve = Curve2D.new()
	curve.add_point(origin, origin, out_control, 0)
	curve.add_point(dest)

	dist = dest.x - origin.x
	self.anim_time = anim_time

	set_process(true)

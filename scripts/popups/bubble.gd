tool
extends Control


func _on_bubble_resized():
	var s = get_size()

	$v.set_position(Vector2(s.x / 2, s.y / 2))
	$v.set_scale(
		Vector2(
			(s.x - 72) / 72,
			s.y / 144
		)
	)
	$h.set_position(Vector2(s.x / 2, s.y / 2))
	$h.set_scale(
		Vector2(
			s.x / 144,
			(s.y - 72) / 72
		)
	)

	$ur.set_position(Vector2(s.x - 72, 0))
	$dl.set_position(Vector2(0, s.y - 72))
	$dr.set_position(Vector2(s.x - 72, s.y - 72))

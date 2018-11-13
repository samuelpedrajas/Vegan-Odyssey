extends Control


export(int) var index = 1 setget _set_index


func prepare():
	$id.set_text(str(index))
	if index == 1:
		$id/star1.show()
		$bg.self_modulate.a = 1.0
	elif index == 2:
		$id/star2.show()
	elif index == 3:
		$id/star3.show()


func _ready():
	prepare()


func _set_index(v):
	index = v


func set_data(record):
	if record.time == null:
		return
	var h = str(int(record.time) / 3600 % 24)
	var m = str(int(record.time) / 60 % 60)
	var s = str(int(record.time) % 60)

	h = h if h.length() > 1 else "0" + h
	m = m if m.length() > 1 else "0" + m
	s = s if s.length() > 1 else "0" + s

	$bg/place1/time.set_text(h + ":" + m + ":" + s)
	$bg/place2/used_broccolis.set_text(str(record.used_broccolis))

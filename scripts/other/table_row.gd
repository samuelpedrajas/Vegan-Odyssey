tool
extends Control


export(int) var index = 1 setget _set_index


func _ready():
	$id.set_text(str(index) + ".")


func _set_index(v):
	index = v
	$id.set_text(str(index) + ".")


func set_data(record):
	if record.time == null:
		return
	var h = str(int(record.time) / 3600 % 24)
	var m = str(int(record.time) / 60 % 60)
	var s = str(int(record.time) % 60)

	h = h if h.length() > 1 else "0" + h
	m = m if m.length() > 1 else "0" + m
	s = s if s.length() > 1 else "0" + s

	$time.set_text(h + ":" + m + ":" + s)
	$used_broccolis.set_text(str(record.used_broccolis))

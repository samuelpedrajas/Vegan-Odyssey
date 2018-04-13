extends Node2D


var music_on = true setget _set_music
var sound_on = true setget _set_sound

signal music_settings_changed
signal sound_settings_changed


func save():
	return {
		'music_on': music_on,
		'sound_on': sound_on
	}


func load(info):
	self.music_on = info.music_on
	self.sound_on = info.sound_on


func _set_music(v):
	music_on = v
	emit_signal("music_settings_changed")


func _set_sound(v):
	sound_on = v
	emit_signal("sound_settings_changed")

extends Node


var music_on = true setget _set_music
var sound_on = true setget _set_sound

signal music_settings_changed
signal sound_settings_changed


func save_info():
	return {
		'music_on': music_on,
		'sound_on': sound_on
	}


func load_info(settings_info):
	self.sound_on = settings_info['sound_on']
	self.music_on = settings_info['music_on']


func _set_music(v):
	music_on = v
	emit_signal("music_settings_changed")


func _set_sound(v):
	sound_on = v
	emit_signal("sound_settings_changed")

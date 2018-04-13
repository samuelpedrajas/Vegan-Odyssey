extends AudioStreamPlayer


func _ready():
	settings.connect("music_settings_changed", self, "update_settings")
	update_settings()


func update_settings():
	if settings.music_on:
		play()
	else:
		stop()

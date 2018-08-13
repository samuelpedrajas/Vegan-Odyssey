extends AudioStreamPlayer


func _ready():
	game.settings.connect("music_settings_changed", self, "update_settings")
	set_volume_db(cfg.MUSIC_VOLUME)


func update_settings():
	if game.settings.music_on:
		play()
	else:
		stop()

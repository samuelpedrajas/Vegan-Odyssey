extends Node2D


var silenced = false

func _ready():
	game.settings.connect("sound_settings_changed", self, "update_settings")
	update_settings()


func play_audio(name):
	if silenced:
		return

	if name == "click":
		$click.play()
	elif name == "merge":
		$merge.play()
	elif name == "bubble":
		$bubble.play()
	elif name == "boom":
		$boom.play()
	elif name == "quack":
		$quack.play()
	elif name == "game_over":
		$game_over.play()
	elif name == "win":
		$win.play()
	elif name == "fireworks":
		$fireworks.play()
	elif name == "prewin":
		$prewin.play()
	elif name == "tick":
		$tick.play()
	elif name == "new_record":
		$new_record.play()
	elif name == "cling":
		$cling.play()
	elif name == "slot_stop":
		$slot_stop.play()
	elif name == "lucky":
		$lucky.play()


func update_settings():
	silenced = not game.settings.sound_on


func play_minigame_music():
	if not game.settings.music_on:
		return
	game.music.set_volume_db(-80)
	$minigame.play()


func stop_minigame_music():
	if not game.settings.music_on:
		return
	$minigame.stop()
	game.music.set_volume_db(cfg.MUSIC_VOLUME)

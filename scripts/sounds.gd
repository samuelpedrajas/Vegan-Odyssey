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


func update_settings():
	if not game.settings.sound_on:
		silenced = true
	else:
		silenced = false

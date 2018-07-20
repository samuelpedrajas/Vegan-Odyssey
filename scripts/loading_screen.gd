extends Control

func _ready():
	admob.start_ads()
	game_loader.goto_scene("res://scenes/game.tscn", $progress_bar)

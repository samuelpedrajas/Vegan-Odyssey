extends Control

func _ready():
	game_loader.goto_scene("res://scenes/game.tscn", $progress_bar)


func _on_timeout_timeout():
	game_loader.admob_loaded = true

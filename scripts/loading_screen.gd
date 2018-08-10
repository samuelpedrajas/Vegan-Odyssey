extends Control

func _ready():
	admob.start_ads()
	game_loader.goto_stage($progress_bar)

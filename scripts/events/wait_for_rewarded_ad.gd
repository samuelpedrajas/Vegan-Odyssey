extends Control

var priority = 7
var back_button = false


var ad_to_show
var loaded = false

var music_playback_pos = 0.0
var reward_amount = 0


func start(ad_to_show):
	if admob.admob_module != null:
		admob.connect("rewarded_loaded", self, "on_rewarded_loaded")
		admob.connect("rewarded_ad_closed", self, "on_rewarded_ad_closed")
		admob.connect("rewarded", self, "on_rewarded")
		admob.connect("rewarded_error", self, "failed_to_load")
		admob.loadRewardedVideo(ad_to_show)
	else:
		game.popup_layer.open("no_more_ads")


func stop():
	if game.popup_layer.popup_exists("game_over"):
		game.popup_layer.popup_stack.back().show()
		game.popup_layer.get_node("blur").show()
	elif game.popup_layer.popup_stack.empty():
		get_tree().set_pause(false)
	queue_free()


func on_rewarded_loaded():
	loaded = true
	music_playback_pos = game.music.get_playback_position()
	game.music.stop()
	$timer.stop()
	hide()


func on_rewarded_ad_closed():
	game.event_layer.stop("wait_for_rewarded_ad")
	game.music.play(music_playback_pos)
	if reward_amount > 0:
		game.effects_layer.play_rewarded_effect(reward_amount)


func on_rewarded(amount):
	game.secretly_set_broccolis(game.broccolis + amount)
	game.save_game()
	if game.popup_layer.popup_exists("game_over"):
		game.popup_layer.close(true, true)
		game.revived = true
	else:
		game.event_layer.stop("broccoli_duck")
	reward_amount = amount


func _on_timer_timeout():
	if not loaded:
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads")


func failed_to_load(errorCode):
	if errorCode == 0:
		print("ad server internal error")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads")
	elif errorCode == 1:
		print("invalid request (ad unit id)")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads")
	elif errorCode == 2:
		print("network error")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("offline")
	elif errorCode == 3:
		print("no more ads")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads")
	else:
		print("weird")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads")

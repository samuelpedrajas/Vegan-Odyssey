extends Control

var priority = 7
var back_button = false


var amount

var music_playback_pos = -1
var reward_amount = 0
var cancel = false
var popup = false


func showRewardedVideo():
	if game.settings.music_on:
		music_playback_pos = game.music.get_playback_position()
		game.music.stop()
	$timer.stop()
	hide()
	admob.showRewardedVideo()


func start(_amount):
	amount = _amount
	if admob.admob_module != null:
		admob.connect("rewarded_loaded", self, "on_rewarded_loaded")
		admob.connect("rewarded_ad_closed", self, "on_rewarded_ad_closed")
		admob.connect("rewarded", self, "on_rewarded")
		admob.connect("rewarded_error", self, "failed_to_load")
		if admob.adIsLoaded:
			showRewardedVideo()
		else:
			admob.loadRewardedVideo()
	else:
		popup = true
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("offline")


func stop():
	if game.popup_layer.popup_exists("game_over") and not popup:
		game.popup_layer.popup_stack.back().show()
		game.popup_layer.get_node("effects/blur").show()
	elif game.popup_layer.popup_stack.empty():
		get_tree().set_pause(false)
	queue_free()


func on_rewarded_loaded():
	if cancel:
		return
	cancel = true
	showRewardedVideo()


func on_rewarded_ad_closed():
	game.event_layer.stop("wait_for_rewarded_ad")
	if music_playback_pos >= 0:
		game.music.play(music_playback_pos)
	if reward_amount > 0:
		game.effects_layer.play_rewarded_effect(reward_amount)


func on_rewarded():
	game.secretly_set_broccolis(game.broccolis + amount)
	game.save_game()
	if game.popup_layer.popup_exists("game_over"):
		game.popup_layer.close(true, true)
		game.revived = true
	else:
		game.event_layer.stop("broccoli_duck")
	reward_amount = amount


func _on_timer_timeout():
	if not admob.adIsLoaded and not cancel:
		cancel = true
		popup = true
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads", game.lang.CANNOT_REACH)


func failed_to_load(errorCode):
	popup = true
	if errorCode == 0:
		print("ad server internal error")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads", game.lang.CANNOT_REACH)
	elif errorCode == 1:
		print("invalid request (ad unit id)")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads", game.lang.CANNOT_REACH)
	elif errorCode == 2:
		print("network error")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("offline")
	elif errorCode == 3:
		print("no more ads")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads", game.lang.NO_MORE_ADS)
	else:
		print("weird")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads", game.lang.CANNOT_REACH)


func rescale(s):
	$message.set_scale(Vector2(s, s))

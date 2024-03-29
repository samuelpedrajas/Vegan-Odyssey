extends Control

var priority = 7
var back_button = false


var amount

var music_playback_pos = -1
var reward_amount = 0
var cancel = false
var popup = false

var do_not_unset_loading = false


func showRewardedVideo():
	if game.settings.music_on:
		music_playback_pos = game.music.get_playback_position()
		game.music.stop()
	$timer.stop()
	hide()
	admob.showRewardedVideo()


func start(_amount):
	game.effects_layer.set_loading()

	if admob.firstRequest or game.purchased:
		game.event_layer.stop("wait_for_rewarded_ad")
		return

	amount = _amount

	admob.connect("rewarded_loaded", self, "on_rewarded_loaded")
	admob.connect("rewarded_ad_closed", self, "on_rewarded_ad_closed")
	admob.connect("rewarded", self, "on_rewarded")
	admob.connect("rewarded_error", self, "failed_to_load")

	admob.connect("consent_form_done", self, "on_consent_form_done")
	admob.connect("consent_done", self, "on_consent_done")
	admob.connect("consent_unknown", self, "on_consent_unknown")
	admob.connect("consent_error", self, "on_consent_error")
	admob.connect("prefers2pay", self, "on_prefers2pay")

	if admob.consentFormLoaded:
		admob.showConsentForm()
	elif admob.admob_module != null:

		if game.personalized_ads == null:
			admob.requestConsent()
		elif admob.adIsLoaded:
			showRewardedVideo()
		else:
			admob.loadRewardedVideo()
			$timer.start()
	else:
		popup = true
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("offline")


func on_consent_done():
	if admob.adIsLoaded:
		showRewardedVideo()
	else:
		admob.loadRewardedVideo()
		$timer.start()


func on_consent_form_done():
	if admob.adIsLoaded:
		showRewardedVideo()
	else:
		admob.loadRewardedVideo()
		$timer.start()


func on_consent_unknown():
	admob.loadConsentForm()


func on_consent_error():
	print("Consent error")
	popup = true
	game.event_layer.stop("wait_for_rewarded_ad")
	game.popup_layer.open("generic_popup", {
		"title": game.lang.OOPS_TITLE, "text": game.lang.CANNOT_REACH
	})


func on_prefers2pay():
	print("prefers ad free")
	popup = true
	do_not_unset_loading = true
	game.event_layer.stop("wait_for_rewarded_ad")
	game.popup_layer.open("purchase")


func stop():
	if not do_not_unset_loading:
		game.effects_layer.unset_loading()

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
		game.popup_layer.close(true, true)
		game.event_layer.stop("broccoli_duck")
	reward_amount = amount


func _on_timer_timeout():
	if not admob.adIsLoaded and not cancel:
		cancel = true
		popup = true
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("generic_popup", {
			"title": game.lang.OOPS_TITLE, "text": game.lang.CANNOT_REACH
		})


func failed_to_load(errorCode):
	popup = true
	if errorCode == 0:
		print("ad server internal error")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("generic_popup", {
			"title": game.lang.OOPS_TITLE, "text": game.lang.CANNOT_REACH
		})
	elif errorCode == 1:
		print("invalid request (ad unit id)")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("generic_popup", {
			"title": game.lang.OOPS_TITLE, "text": game.lang.CANNOT_REACH
		})
	elif errorCode == 2:
		print("network error")
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("offline")
	else:
		print("no more ads")

		game.event_layer.stop("wait_for_rewarded_ad")

		if game.error9_count >= 1 and game.given_gifts < 5 and game.broccolis < 5:
			game.given_gifts += 1
			game.popup_layer.open("error9")
		elif game.error9_count == 0 and game.given_gifts < 5 and game.broccolis < 5:
			game.error9_count += 1
			game.given_gifts += 1
			game.popup_layer.open("no_more_ads")
		else:
			game.popup_layer.open("generic_popup", {
				"title": game.lang.OOPS_TITLE, "text": game.lang.NO_MORE_ADS
			})


func rescale(s):
	pass

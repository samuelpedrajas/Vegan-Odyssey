extends Node2D

#var is_banner_loaded = false

var admob_module = null
var isReal = false

var adRewardedId = "ca-app-pub-1160358939410189/9596791523"
var adRewarded2 = 2
var adRewarded3 = 3

var adIsLoaded = false
var firstRequest = true
var consentFormLoaded = false


signal rewarded_error
signal rewarded_loaded
signal rewarded_ad_closed
signal rewarded

signal consent_form_done
signal consent_done
signal consent_unknown
signal consent_error
signal prefers2pay


func start_ads():
	if(Engine.has_singleton("AdMob") and not game.purchased):
		print("Starting AdMob")
		admob_module = Engine.get_singleton("AdMob")
		admob_module.init(isReal, get_instance_id())

		requestConsent()

	if not get_tree().is_connected("screen_resized", self, "on_resize"):
		get_tree().connect("screen_resized", self, "on_resize")


func get_rewarded_ad_info():
	return adRewarded2


func loadRewardedVideo():
	if admob_module != null and not adIsLoaded:
		admob_module.loadRewardedVideo(adRewardedId, game.personalized_ads)


func showRewardedVideo():
	if admob_module != null:
		adIsLoaded = false
		admob_module.showRewardedVideo()


# rewarded loaded callback

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	game.error9_count = 0
	adIsLoaded = true
	emit_signal("rewarded_loaded")


# rewarded load error callback

func _on_rewarded_video_ad_failed_to_load(errorCode):
	print("Rewarded failed to load: " + str(errorCode))
	adIsLoaded = false
	emit_signal("rewarded_error", errorCode)


# rewarded video closed -- also called on rewarded

func _on_rewarded_video_ad_closed():
	print("Rewarded closed by user")
	emit_signal("rewarded_ad_closed")
	loadRewardedVideo()


# rewarded video on reward

func _on_rewarded(currency, amount):
	print("Reward: " + currency + ", " + str(amount))
	emit_signal("rewarded")
	if not game.board_layer.check_moves_available():
		game.hud_layer.glow_broccoli()


# resize
func on_resize():
	if game.resizer != null:
		game.resizer.rescale_all()


func getHeight():
	if OS.get_name() == "iOS" and Engine.has_singleton("MobileTools"):
		var mobile_tools = Engine.get_singleton("MobileTools")
		if mobile_tools.theresSafeArea():
			return 40.0 + mobile_tools.getSafeMarginBottom()

	return 40.0


# consent

func requestConsent():
	if admob_module != null:
		admob_module.requestConsent()


func loadConsentForm():
	if admob_module != null:
		admob_module.loadConsentForm(game.lang.language)


func showConsentForm():
	if admob_module != null:
		consentFormLoaded = false
		admob_module.showConsentForm()


func isRequestLocationInEeaOrUnknown():
	if admob_module != null:
		return admob_module.isRequestLocationInEeaOrUnknown()
	return false


# consent callbacks

func _on_consent_info_updated(status):
	print("Consent status: ", status)
	var is_eea = isRequestLocationInEeaOrUnknown()
	if firstRequest:
		if is_eea and status == "unknown":
			game.personalized_ads = null
			game.save_game()
			loadConsentForm()
		elif not is_eea:
			firstRequest = false
			game.personalized_ads = true
			game.save_game()
			admob_module.setConsent(game.personalized_ads)
			loadRewardedVideo()
		else:
			firstRequest = false
			loadRewardedVideo()

	elif status == "personalized" or not is_eea:
		game.personalized_ads = true
		game.save_game()
		admob_module.setConsent(game.personalized_ads)
		emit_signal("consent_done")
	elif status == "non_personalized":
		game.personalized_ads = false
		game.save_game()
		admob_module.setConsent(game.personalized_ads)
		emit_signal("consent_done")
	else:
		game.personalized_ads = null
		game.save_game()
		emit_signal("consent_unknown")


func _on_consent_form_loaded():
	print("Consent form loaded")
	consentFormLoaded = true
	if firstRequest:
		firstRequest = false
	else:
		showConsentForm()


func _on_consent_form_closed(status, user_prefers_ad_free):
	print("Consent form closed: ", status, " ", user_prefers_ad_free)

	if user_prefers_ad_free:
		game.personalized_ads = null
		game.save_game()
		emit_signal("prefers2pay")
	elif status == "personalized":
		game.personalized_ads = true
		game.save_game()
		admob_module.setConsent(game.personalized_ads)
		emit_signal("consent_form_done")
	elif status == "non_personalized":
		game.personalized_ads = false
		game.save_game()
		admob_module.setConsent(game.personalized_ads)
		emit_signal("consent_form_done")
	else:
		emit_signal("consent_error")


func _on_consent_error(error_description):
	print("Consent error: ", error_description)
	if firstRequest:
		firstRequest = false
	emit_signal("consent_error")

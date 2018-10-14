extends Node2D

#var is_banner_loaded = false

var admob_module = null
var isReal = false

var adRewardedId = "ca-app-pub-3940256099942544/1712485313"
var adRewarded2 = 2
var adRewarded3 = 3

var adIsLoaded = false


signal rewarded_error
signal rewarded_loaded
signal rewarded_ad_closed
signal rewarded


func start_ads():
	if(Engine.has_singleton("AdMob")):
		print("Starting AdMob")
		admob_module = Engine.get_singleton("AdMob")
		admob_module.init(isReal, get_instance_id())
		loadRewardedVideo()

	if not get_tree().is_connected("screen_resized", self, "on_resize"):
		get_tree().connect("screen_resized", self, "on_resize")


func get_rewarded_ad_info():
	return adRewarded2


func loadRewardedVideo():
	if admob_module != null and not adIsLoaded:
		admob_module.loadRewardedVideo(adRewardedId)


func showRewardedVideo():
	if admob_module != null:
		adIsLoaded = false
		admob_module.showRewardedVideo()


# rewarded loaded callback

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
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
	return 40.0

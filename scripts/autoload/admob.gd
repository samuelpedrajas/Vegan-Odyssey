extends Node2D

var is_banner_loaded = false

var admob_module = null
var isReal = false
var isTop = false
var adBannerId = "ca-app-pub-3940256099942544/6300978111" # [Replace with your Ad Unit ID and delete this message.]
var adRewarded1 = {
	"id": "ca-app-pub-1160358939410189/4323604305",
	"amount": 1
}
var adRewarded2 = {
	"id": "ca-app-pub-1160358939410189/7595553335",
	"amount": 2
}
var adRewarded3 = {
	"id": "ca-app-pub-1160358939410189/4394674925",
	"amount": 3
}

var loadedReward = null  # needed for debugging


signal banner_loaded
signal banner_network_error

signal rewarded_error
signal rewarded_loaded
signal rewarded_ad_closed
signal rewarded


func start_ads():
	if(Engine.has_singleton("AdMob")):
		print("Starting AdMob")
		admob_module = Engine.get_singleton("AdMob")
		admob_module.init(isReal, get_instance_id())
		loadBanner()

	if not get_tree().is_connected("screen_resized", self, "on_resize"):
		get_tree().connect("screen_resized", self, "on_resize")


func showBanner():
	if admob_module:
		admob_module.showBanner()


func get_rewarded_ad_info():
	var tmp = max(1, 3 - game.broccolis)
	var amount = min(2, tmp)

	if game.current_max < 8:
		amount = 1

	if amount == 1:
		return adRewarded1
	elif amount == 2:
		return adRewarded2
	else:
		return adRewarded3


# loaders
func loadBanner():
	if admob_module != null:
		admob_module.loadBanner(adBannerId, isTop)
		if game.seen_intro:
			admob_module.showBanner()
		else:
			admob_module.hideBanner()


var max_attempts = 3
var current_attempts = 0


func loadRewardedVideo(ad_to_show):
	# still pending request
	if loadedReward != null:
		current_attempts += 1
		if current_attempts == max_attempts or loadedReward != ad_to_show:
			loadedReward = null
			current_attempts = 0

	if admob_module != null and loadedReward == null:
		admob_module.loadRewardedVideo(ad_to_show.id)
		loadedReward = ad_to_show
		print("Reward " + str(ad_to_show.amount) + " broccolis")


# players

func showRewardedVideo():
	if admob_module != null:
		admob_module.showRewardedVideo()


# banner loaded callback

func _on_admob_ad_loaded():
	print("Ad loaded success")
	is_banner_loaded = true
	if game.seen_intro:
		admob_module.showBanner()
	else:
		admob_module.hideBanner()
	emit_signal("banner_loaded")


# banner load error callback

func _on_admob_network_error():
	print("Network Error")
	emit_signal("banner_network_error")


# rewarded loaded callback

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	emit_signal("rewarded_loaded")


# rewarded load error callback

func _on_rewarded_video_ad_failed_to_load(errorCode):
	print("Rewarded failed to load: " + str(errorCode))
	emit_signal("rewarded_error", errorCode)
	loadedReward = null


# rewarded video closed -- also called on rewarded

func _on_rewarded_video_ad_closed():
	print("Rewarded closed by user")
	emit_signal("rewarded_ad_closed")
	loadedReward = null


# rewarded video on reward

func _on_rewarded(currency, amount):
	print("Reward: " + currency + ", " + str(amount))
	emit_signal("rewarded", amount)
	if not game.board_layer.check_moves_available():
		game.hud_layer.glow_broccoli()
	loadedReward = null


# resize
func on_resize():
	if admob_module != null:
		admob_module.resize()
		if game.resizer != null:
			game.resizer.rescale_all()
		print("RESIZE")


var last_height = 160

func getHeight():
	var banner_height = 160.0
	if admob_module != null:
		var screen_size = get_viewport().get_visible_rect().size
		var screen_diagonal = sqrt(pow(screen_size.x, 2) + pow(screen_size.y, 2))

		banner_height = admob_module.getBannerHeight()
		banner_height = banner_height / game.resizer.device_diagonal * screen_diagonal

		if OS.get_name() == "iOS":
			var mobile_tools = Engine.get_singleton("MobileTools")
			if mobile_tools.theresSafeArea():
				var safe_margin_px = mobile_tools.getSafeMarginBottom()
				safe_margin_px = safe_margin_px / game.resizer.device_diagonal * screen_diagonal
				banner_height += safe_margin_px

	# if still 0 or less (probably not needed)
	if banner_height <= 0:
		banner_height = 160.0

	last_height = banner_height

	return banner_height

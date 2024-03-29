extends Control


func _ready():
	if not admob.isRequestLocationInEeaOrUnknown():
		get_parent().hide()
	elif not game.purchased:
		admob.connect("consent_form_done", self, "on_consent_form_done")
		admob.connect("consent_done", self, "on_consent_done")
		admob.connect("consent_unknown", self, "on_consent_unknown")
		admob.connect("consent_error", self, "on_consent_error")
		admob.connect("prefers2pay", self, "on_prefers2pay")


func managed_pressed():
	if not admob.firstRequest and not game.purchased:
		game.effects_layer.set_loading()
		if admob.consentFormLoaded:
			admob.showConsentForm()
		else:
			admob.requestConsent()


func on_consent_form_done():
	game.effects_layer.unset_loading()


func on_consent_done():
	if admob.isRequestLocationInEeaOrUnknown():
		admob.loadConsentForm()
	else:
		print("Device not in EEA")
		game.effects_layer.unset_loading()
		game.popup_layer.open("not_eea")


func on_consent_unknown():
	if admob.isRequestLocationInEeaOrUnknown():
		admob.loadConsentForm()
	else:
		print("Device not in EEA")
		game.effects_layer.unset_loading()
		game.popup_layer.open("not_eea")


func on_consent_error():
	print("Consent error")
	game.effects_layer.unset_loading()
	game.popup_layer.open("generic_popup", {
		"title": game.lang.OOPS_TITLE,
		"text": game.lang.CANNOT_REACH
	})


func on_prefers2pay():
	print("Prefers to ad free")
	game.popup_layer.open("purchase", self)


func _on_manage_ads_label_btn_pressed():
	managed_pressed()


func _on_wheel_pressed():
	managed_pressed()

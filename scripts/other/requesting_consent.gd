extends TextureRect


func _ready():
	admob.connect("consent_form_done", self, "on_consent_form_done")
	admob.connect("consent_done", self, "on_consent_done")
	admob.connect("consent_unknown", self, "on_consent_unknown")
	admob.connect("consent_error", self, "on_consent_error")
	admob.connect("prefers2pay", self, "on_prefers2pay")


func _on_manage_ads_pressed():
	if not admob.firstRequest:
		$"/root".set_disable_input(true)
		$text.update_language()
		$anim.play("set_black")
		yield($anim, "animation_finished")
		if admob.consentFormLoaded:
			admob.showConsentForm()
		else:
			admob.requestConsent()


func close():
	$anim.play("unset_black")
	yield($anim, "animation_finished")
	$"/root".set_disable_input(false)


func on_consent_form_done():
	close()


func on_consent_done():
	if admob.isRequestLocationInEeaOrUnknown():
		admob.loadConsentForm()
	else:
		print("Device not in EEA!")


func on_consent_unknown():
	if admob.isRequestLocationInEeaOrUnknown():
		admob.loadConsentForm()
	else:
		print("Device not in EEA!")


func on_consent_error():
	print("ERROR!!!")
	close()


func on_prefers2pay():
	print("Prefers to pay!!!")
	close()

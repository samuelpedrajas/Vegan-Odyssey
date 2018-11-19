extends "popup.gd"


var back_button = false
var keep_input_disabled = true
var keep_previous = false
var show_blur = false


func _ready():
	if OS.get_name() == "iOS" or OS.get_name() == "Android":
		iap_helper.connect(
			"request_product_info_success", self, "on_request_product_info_success"
		)
		iap_helper.connect(
			"request_product_info_error", self, "on_request_product_info_error"
		)

		iap_helper.connect(
			"purchase_success", self, "on_purchase_success"
		)
		iap_helper.connect(
			"purchase_error", self, "on_purchase_error"
		)

		iap_helper.connect(
			"restore_purchases_success", self, "on_restore_purchases_success"
		)
		iap_helper.connect(
			"restore_purchases_error", self, "on_restore_purchases_error"
		)
		iap_helper.connect(
			"restore_purchases_not_owned", self, "on_restore_purchases_not_owned"
		)

		iap_helper.request_product_info()


func on_request_product_info_success(prices):
	print("REQUEST PRODUCT SUCCESS")
	if prices.size() < 1:
		game.popup_layer.close()
		game.popup_layer.open("generic_popup", {
			"title": game.lang.OOPS_TITLE, "text": game.lang.CANNOT_REACH
		})
	else:
		$window/ok.set_price(prices[0])
		game.effects_layer.unset_loading()
		$animation.play("load_form")
		yield($animation, "animation_finished")
		$"/root".set_disable_input(false)


func on_request_product_info_error():
	game.popup_layer.close()
	game.popup_layer.open("generic_popup", {
		"title": game.lang.OOPS_TITLE, "text": game.lang.CANNOT_REACH
	})


func on_purchase_success():
	print("PURCHASE SUCCESS!!")
	game.purchased = true
	game.save_game()

	close_anim = "close_form"
	game.popup_layer.close()
	game.popup_layer.open("purchase_instructions")


func on_purchase_error():
	close_anim = "close_form"
	game.effects_layer.unset_loading()
	game.popup_layer.open("generic_popup", {
		"title": game.lang.OOPS_TITLE, "text": game.lang.PURCHASE_UNSUCCESSFUL2
	})


func on_restore_purchases_success():
	print("RESTORE PURCHASE SUCCESS!!")
	game.purchased = true
	game.save_game()

	close_anim = "close_form"
	game.popup_layer.close()
	game.popup_layer.open("purchase_instructions")


func on_restore_purchases_error():
	close_anim = "close_form"
	game.effects_layer.unset_loading()
	game.popup_layer.open("generic_popup", {
		"title": game.lang.OOPS_TITLE, "text": game.lang.CANNOT_REACH
	})


func on_restore_purchases_not_owned():
	close_anim = "close_form"
	game.effects_layer.unset_loading()
	game.popup_layer.open("generic_popup", {
		"title": game.lang.OOPS_TITLE, "text": game.lang.NOT_OWNED
	})


func open():
	game.effects_layer.set_loading()


func close():
	game.effects_layer.unset_loading()
	.close()


func _on_ok_pressed():
	$"/root".set_disable_input(true)
	game.sounds.play_audio("click")
	game.effects_layer.set_loading()
	iap_helper.purchase()


func _on_already_owned_pressed():
	$"/root".set_disable_input(true)
	game.sounds.play_audio("click")
	game.effects_layer.set_loading()
	iap_helper.restore_purchases()


func rescale(s):
	$window.set_scale(Vector2(s, s))
	$window/go_back.set_right_pos()


func _on_go_back_pressed():
	close_anim = "close_form"
	game.popup_layer.close()


func _on_timer_timeout():
	print("checking events...")
	iap_helper.check_events()

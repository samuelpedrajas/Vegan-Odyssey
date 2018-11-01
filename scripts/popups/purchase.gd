extends "popup.gd"


var back_button = false
var keep_input_disabled = true
var keep_previous = false
var show_blur = false


func _ready():
	if OS.get_name() == "iOS":
		ios_iap.connect(
			"request_product_info_success", self, "on_request_product_info_success"
		)
		ios_iap.connect(
			"request_product_info_error", self, "on_request_product_info_error"
		)

		ios_iap.connect(
			"purchase_success", self, "on_purchase_success"
		)
		ios_iap.connect(
			"purchase_error", self, "on_purchase_error"
		)

		ios_iap.connect(
			"restore_purchases_success", self, "on_restore_purchases_success"
		)
		ios_iap.connect(
			"restore_purchases_error", self, "on_restore_purchases_error"
		)
		ios_iap.connect(
			"restore_purchases_not_owned", self, "on_restore_purchases_not_owned"
		)

		ios_iap.request_product_info()


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
		"title": game.lang.OOPS_TITLE, "text": game.lang.CANNOT_REACH
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
	ios_iap.purchase()


func _on_already_owned_pressed():
	$"/root".set_disable_input(true)
	game.sounds.play_audio("click")
	game.effects_layer.set_loading()
	ios_iap.restore_purchases()


func rescale(s):
	$window.set_scale(Vector2(s, s))


func _on_go_back_pressed():
	close_anim = "close_form"
	game.popup_layer.close()


func _on_timer_timeout():
	print("checking events...")
	ios_iap.check_events()

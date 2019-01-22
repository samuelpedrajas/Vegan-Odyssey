extends Control


onready var token = $token
onready var animation = $token/animation

var angular_speed = 2
var speed = Vector2(400.0, -1200.0)
var is_dying = false


func _ready():
	set_process(false)
	if game.lang.language == "es":
		$token/sprite_1_es.show()
		$token/sprite_1_en.hide()


func _process(delta):
	if is_dying:
		var gravity = Vector2(0, 5000)  # px / s^2
		speed += gravity * delta
		token.position += speed * delta
		token.rotation = token.rotation + (angular_speed * delta)
		if modulate.a > 0:
			modulate.a = max(0, modulate.a - delta / modulate.a)
		else:
			set_process(false)
			queue_free()

func die():
	is_dying = true
	set_process(true)


func merge():
	animation.play("merge")


func level_up():
	if game.lang.language == "es":
		$token/sprite_2_es.show()
		$token/sprite_1_es.hide()
	else:
		$token/sprite_2_en.show()
		$token/sprite_1_en.hide()
	$token/circle2.show()
	$token/circle1.hide()

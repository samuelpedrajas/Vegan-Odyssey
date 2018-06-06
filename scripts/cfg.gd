extends Node

const DEBUG_MODE = false
const DEV_MODE = true
const GOAL = 9

const MIN_HIGHEST_MAX = 4

# Directions available for input
const DIRECTIONS = [
	Vector2(1, 0), Vector2(-1, 0),  # Horizontal: -
	Vector2(0, 1), Vector2(0, -1)  # Vertical: |
]

const ANIMATION_TIME = 0.12  # token's animation time in seconds
const MOVEMENT_OPACITY = 0.8  # opacity when moving

const MOTION_DISTANCE = 15  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.6 # Minimum distance from the direction vectors to make a move

const SETTINGS_WINDOW_POS = Vector2(540, 860)
const BOOK_WINDOW_POS = Vector2(540, 860)
const EXIT_WINDOW_POS = Vector2(540, 850)
const RESET_WINDOW_POS = Vector2(540, 850)
const RESET_PROGRESS_WINDOW_POS = Vector2(540, 850)
const EXCUSE_WINDOW_POS = Vector2(540, 960)
const REWARDED_VIDEO_WINDOW_POS = Vector2(540, 850)
const NO_MORE_ADS_WINDOW_POS = Vector2(540, 850)
const OFFLINE_WINDOW_POS = Vector2(540, 850)

const DUCK_TIME = 15

const SCROLL_THRESHOLD = 10

const SAVE_GAME_PATH = "user://savegame.save"

# excuse info
var EXCUSES = [
	{
		"token_sprite": preload("res://images/excuses/lions.png"),
		"book_sprite": preload("res://images/excuse_pictures/lions.png"),
		"path": "res://share/lions.share",
		"text": "Lions eat meat",
		"debate": {
			"question": "But don’t lions eat meat?",
			"answer": "Well… yes. But in nature lions also commit atrocities like infanticide. What would you think if I picked any of these behaviors and said: “it’s fine, lions do it”?",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/proteins.png"),
		"book_sprite": preload("res://images/excuse_pictures/proteins.png"),
		"path": "res://share/proteins.share",
		"text": "Proteins",
		"debate": {
			"question": "But don’t we need animal proteins?",
			"answer": "Whole grains, vegetables, and beans provide more than enough protein to be healthy. It’s very difficult to be protein-deficient if you get all calories you need.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/plantshavefeelings.png"),
		"book_sprite": preload("res://images/excuse_pictures/plantshavefeelings.png"),
		"path": "res://share/plantshavefeelings.share",
		"text": "Plants have feelings",
		"debate": {
			"question": "But don’t plants have feelings too?",
			"answer": "They don’t! They lack of central nervous systems and pain receptors. Neuroscientists say that pain is something created by a brain so... no brain, no pain.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/bacon.png"),
		"book_sprite": preload("res://images/excuse_pictures/bacon.png"),
		"path": "res://share/bacon.share",
		"text": "Mmhh... Bacon",
		"debate": {
			"question": "Bacon, tho.",
			"answer": "Oh, c’mon. That’s not even an argument. A clear conscience tastes better than the best bacon in the world, don’t you think so?",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/desertedisland.png"),
		"book_sprite": preload("res://images/excuse_pictures/desertedisland.png"),
		"path": "res://share/desertedisland.share",
		"text": "Deserted island",
		"debate": {
			"question": "What if you were in a deserted island?",
			"answer": "And what if you were in a civilization full of cruelty free options? You can’t justify your everyday actions on “what would you do” in some extreme situation.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/legal.png"),
		"book_sprite": preload("res://images/excuse_pictures/legal.png"),
		"path": "res://share/legal.share",
		"text": "It's legal",
		"debate": {
			"question": "Eating meat is legal.",
			"answer": "Legal doesn’t mean moral. Slavery in the form of people ownership was legal for almost all history of civilizations. Bringing up legality is not enough.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/moral.png"),
		"book_sprite": preload("res://images/excuse_pictures/moral.png"),
		"path": "res://share/moral.share",
		"text": "Morality is subjective",
		"debate": {
			"question": "Morality is subjective. I’ve got my truth.",
			"answer": "That sounds kind of dangerous, doesn’t it? You could literally justify any behavior by saying that. Animals want to live, their perspective also matters.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/caveman.png"),
		"book_sprite": preload("res://images/excuse_pictures/caveman.png"),
		"path": "res://share/caveman.share",
		"text": "Caveman ate meat",
		"debate": {
			"question": "I eat meat because cavemen ate meat.",
			"answer": "Ha! Are you really going to justify your actions on “what would cavemen do”? Are you doing this in the rest of your life decisions? Why use this for nutrition?",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/canine.png"),
		"book_sprite": preload("res://images/excuse_pictures/canine.png"),
		"path": "res://share/canine.share",
		"text": "Canine teeth",
		"debate": {
			"question": "But isn’t it how the circle of life works?",
			"answer": "“Circle of life” is just a term we created to refer to the general tendency towards an equilibrium we can see in nature, but it’s not a law written on stone.",
		}
	}
]

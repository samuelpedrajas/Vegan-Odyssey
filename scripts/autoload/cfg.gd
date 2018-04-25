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
const SPAWN_ANIMATION_TIME = 0.1
const MOVEMENT_OPACITY = 0.8  # opacity when moving

const MOTION_DISTANCE = 15  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.6 # Minimum distance from the direction vectors to make a move

const SETTINGS_WINDOW_POS = Vector2(540, 1000)
const BOOK_WINDOW_POS = Vector2(540, 700)
const EXIT_WINDOW_POS = Vector2(540, 850)
const RESET_WINDOW_POS = Vector2(540, 850)
const RESET_PROGRESS_WINDOW_POS = Vector2(540, 850)
const EXCUSE_WINDOW_POS = Vector2(540, 800)
const SCROLL_THRESHOLD = 10

const SAVE_GAME_PATH = "user://savegame.save"

# excuse info
var EXCUSES = [
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/lions.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/lions.png"),
		"text": "Lions eat meat"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/plantshavefeeling.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/plantshavefeeling.png"),
		"text": "Plants have feelings"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/desertedisland.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/desertedisland.png"),
		"text": "Lost in a deserted island"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/ancestors.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/caveman.png"),
		"text": "We are like cavemen"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/bacon.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/bacon.png"),
		"text": "Mmhh... Bacon"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/canineteeth.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/canineteeth.png"),
		"text": "Look at my canine teeth!"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/onepersonmakesnodifference.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/legal.png"),
		"text": "It's legal to eat meat"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/b12.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/moral.png"),
		"text": "Morality is subjective"
	},
	{
		"token_sprite": ResourceLoader.load("res://images/excuses/proteins.png"),
		"book_sprite": ResourceLoader.load("res://images/excuse_pictures/proteins.png"),
		"text": "What about proteins?"
	}
]

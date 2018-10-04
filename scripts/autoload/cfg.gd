extends Node

const DEV_MODE = true
const GOAL = 9

const MIN_HIGHEST_MAX = 1

# Directions available for input
const DIRECTIONS = [
	Vector2(1, 0), Vector2(-1, 0),  # Horizontal: -
	Vector2(0, 1), Vector2(0, -1)  # Vertical: |
]

const ANIMATION_TIME = 0.12  # token's animation time in seconds
const MOVEMENT_OPACITY = 0.8  # opacity when moving

const MOTION_DISTANCE = 15  # Minimum distance with the mouse pressed to make a move
const MINIMUM_DISTANCE_TO_MOVE = 0.6 # Minimum distance from the direction vectors to make a move

const SCROLL_THRESHOLD = 10

const SAVE_GAME_PATH = "user://savegame.save"

const TRANSLATIONS = {
	"es": "res://translations/es.gd",
	"en": "res://translations/en.gd"
}

const MUSIC_VOLUME = -12

const LOW_BTN_MARGIN = 15
const HIGH_BTN_MARGIN = 40
var BOARD_POSITION = 0.5

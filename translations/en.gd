extends Node


var language = "en"


var opening = [
	["B", "(lucy_salutes)(lau_happy_listening)Laura! Wow! (lau_salutes)Long-time no see! It's so great to see you again."],
	["A", "(lucy_smiling)Lucy! (lau_happy_talking)What’s new? I’ve heard you’ve gone vegan! Is that true(lau_happy_listening)?"],
	["B", "(lau_happy_listening)(lucy_happy)You’ve heard correct. I researched about it and I realised we can live perfectly fine without eating or using animals(lucy_smiling)."],
	["A", "(lau_happy_talking)What? That doesn’t make any sense(lucy_listening)(lau_proud)."],
	["B", "(lucy_stand_talking)Why?(lucy_listening)"],
	["A", "(lau_finger)Because... WHAT (music)IF YOU WERE IN A DESERTED ISLAND(lau_proud)(lucy_serious)?"]
]


var dialog_list = [
	[
		["A", "(lau_talking)(lucy_listening)What if you were in a deserted island?"],
		["B", "(lau_listening)(lucy_talking)Well, honestly I don't know. I hope I'm never in that situation. But what if you were in a civilization full of cruelty free options?"],
		["B", "You cannot justify your everyday actions on “what would you do” in some extreme situation. That would be extreme, indeed(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)But don't plants have feelings too?"],
		["B", "(lau_listening)(lucy_talking)Well, we usually make analogies between humans and plants to grasp complex concepts intuitively. But, in reality, plants are totally different than us."],
		["B", "They lack a central nervous system and pain receptors. According to neuroscientists, pain is caused by signals from the brain. So... (lucy_happy)no brain, no pain."],		
		["B", "And... Did you know that you need 16 kg of plants to feed 1 kg of beef? (lucy_happy)So, if you’re still interested in saving plants you’ve got to go vegan(lucy_smiling)!"]
	], [
		["A", "(lau_talking)(lucy_listening)What you vegans don't understand is that (lau_finger)we need animal protein to survive(lau_proud)."],
		["B", "(lau_listening)(lucy_happy)Well, do I look like a zombie to you? I'm sorry Laura, (lucy_talking)but that's a false statement. Humans don't need animal protein to survive."],
		["B", "Whole grains, vegetables, and beans provide more than enough protein to stay healthy. It's very difficult for someone to become protein-deficient if they are still consuming all the calories that they need."],
		["B", "(lucy_happy)There are many professional athletes that are living a vegan lifestyle. They're a minority, yes, (lucy_talking)but vegans are also a minority in the global population(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)I think humans eat meat because it's just how “the circle of life” works."],
		["B", "(lau_listening)(lucy_talking)Well, the term “circle of life” was created to refer to the general tendency towards the equilibrium we can see in the animal kingdom, but it's not a law that has been written in stone."],
		["B", "Keeping animals in cages with no chance of freedom shouldn’t be part of any “circle of life”, neither can be genetically modifying them for human consumption."],
		["B", "It's entirely up to you to go vegan, no natural law is forcing you to stop or keep consuming animal products. That means you've got a decision to make(lucy_smiling)."]
	], [
		["A", "(lucy_smiling)(lau_serious_talking)Bacon, though(lau_proud)(lucy_serious)."],
		["B", "Uhm... (lucy_stand_talking)I don't think that even deserves an answer, but I'll ask you something:(lucy_talking_arm) do you support bullfighting?(lucy_listening)"],
		["A", "(lau_finger)Absolutely not! That's clear-cut animal abuse(lau_proud)."],
		["B", "(lucy_stand_talking)Well, bullfighters say it's an art. (lucy_talking)(lau_listening)They will tell you that they get pleasure from it through their eyes rather than through taste."],
		["B", "In both cases, personal pleasure is placed before animal welfare. I don't think that's a very responsible way to set priorities(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)I eat meat because lions eat meat. If they can do it, why can't I?(lau_proud)"],
		["B", "(lucy_talking)Well, as far as we know you are not a lion... (lucy_happy)or are you? (lau_listening)"],
		["B", "(lucy_talking)In the wild, lions often commit infanticide and, from a human perspective, other violent acts. What would you think if I picked any of these behaviors and said: “it's fine, lions do it too”?"],
		["B", "They can't choose because their nature limit their options, but we can. We are very different from them, (lucy_happy)don't you think so?(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Cavemen ate meat, that's why I eat meat(lau_proud)."],
		["B", "(lucy_talking)Ha! Are you really going to justify your actions on “what would cavemen do”?(lau_listening) Are you doing this with the rest of your life decisions? Why then use this for nutrition?"],
		["B", "Cavemen ate whatever they could find in their environment. Also, they did not have a population of 7.6 billion, so our circumstances as species have changed."],
		["B", "If it's health what concerns you, a vegan diet is perfectly suitable for your body even if you're a professional athlete. It's easy to find information about this(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Eating meat is legal, so what's the problem?(lau_listening)"],
		["B", "(lucy_talking)Well, there's one thing you should learn then: legal doesn't mean moral. Slavery in the form of owning people as property was legal for most of the history of civilization."],
		["B", "Also, not so long ago, women were not even considered people in the eyes of legality. They were property of their husbands. This was legal, sure, but obviously not right."],
		["B", "Laws are written by humans and can often be wrong. This is why our ambition and will to improve must go beyond any law(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Morality is subjective. You've got your truth, I've got mine(lau_proud)."],
		["B", "(lucy_talking)That sounds kind of dangerous, doesn't it? (lau_listening)You could literally justify any behavior by saying that."],
		["B", "You need to come up with a good argument because when an animal is killed, is not only your subjectivity that matters. Animals want to live, and their perspective matters as well."],
		["B", "We're killing more than 60 billion land animals every year, and this is having a catastrophic impact on our environment. Is there really any good justification to keep doing this(lucy_smiling)?"]
	]
]


var ending = [
	["A", "(lau_talking_open_eyes)(lucy_smiling)Well… Honestly, I never thought about it in that way."],
	["B", "(lucy_talking)(lau_happy_listening)Yeah, it’s something that is embedded in our culture, but that doesn’t make it right."],
	["A", "(lucy_smiling)(lau_talking_open_eyes)That makes sense. (lau_happy_talking)Thanks Lucy! You really make me think. (lau_talking_open_eyes)Veganism is much more important than I thought."],
	["B", "(lucy_happy)(lau_happy_listening)I’m glad to hear that! And the truth is the sacrifice you would be making is very small compared to the good you will be contributing to the Earth."],
	["A", "(lucy_smiling)I see. (lau_happy_talking)I’ll keep all this in mind for the next time I go to the supermarket. (lau_salutes)Thanks again Lucy!(lucy_salutes)"]
]


# share
const TITLE = "Vegan Oddysey"
const SUBJECT = "Play Vegan Oddysey for iOS and Android."
const MSG = "Play Vegan Oddysey for iOS and Android. Download it for free at https://www.veganodysseythegame.com"


# excuse info
var EXCUSES = [
	{
		"token_sprite": preload("res://images/excuses/en/desertedisland.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/desertedisland.png"),
		"path": "res://share/en/desertedisland.share",
		"text": "Deserted island",
		"debate": {
			"question": "What if you were in a deserted island?",
			"answer": "And what if you were in a civilization full of cruelty free options? You can’t justify your everyday actions on “what would you do” in some extreme situation.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/en/plantshavefeelings.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/plantshavefeelings.png"),
		"path": "res://share/en/plantshavefeelings.share",
		"text": "Plants have feelings",
		"debate": {
			"question": "But don’t plants have feelings too?",
			"answer": "They don’t! They lack a central nervous system and pain receptors. According to neuroscientists, pain is caused by the brain. So... no brain, no pain.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/en/proteins.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/proteins.png"),
		"path": "res://share/en/proteins.share",
		"text": "Proteins",
		"debate": {
			"question": "But don’t we need animal protein?",
			"answer": "Whole grains, vegetables, and beans provide more than enough protein to be healthy. It’s difficult to become protein-deficient if you consume all calories that you need.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/en/circleoflife.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/circleoflife.png"),
		"path": "res://share/en/circleoflife.share",
		"text": "Circle Of Life",
		"debate": {
			"question": "But isn’t it how “the circle of life” works?",
			"answer": "“Circle of life” is a term we created to refer to the general tendency towards an equilibrium we see in nature, but it’s not a law written in stone.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/bacon.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/bacon.png"),
		"path": "res://share/en/bacon.share",
		"text": "Mmhh... Bacon",
		"debate": {
			"question": "Bacon, though.",
			"answer": "Oh, c’mon. That’s not even an argument. A clean conscience tastes better than the best bacon in the world, don’t you think so?",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/en/lions.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/lions.png"),
		"path": "res://share/en/lions.share",
		"text": "Lions eat meat",
		"debate": {
			"question": "But don’t lions eat meat too?",
			"answer": "Well… yes. But lions in the wild also kill their own young. What would you think if I picked any of these behaviors and said: “it’s fine, lions do it too”?",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/en/caveman.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/caveman.png"),
		"path": "res://share/en/caveman.share",
		"text": "Caveman ate meat",
		"debate": {
			"question": "I eat meat because cavemen ate meat.",
			"answer": "Ha! Are you really going to justify your actions on “what would cavemen do”? Are you doing this with the rest of your life decisions? Why then use this for nutrition?",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/en/legal.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/legal.png"),
		"path": "res://share/en/legal.share",
		"text": "It's legal",
		"debate": {
			"question": "Eating meat is legal.",
			"answer": "Legal doesn’t mean moral. Slavery in the form of owning people as property was legal for most of the history of civilizations. Bringing up legality is not enough.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/en/moral.png"),
		"book_sprite": preload("res://images/excuse_pictures/en/moral.png"),
		"path": "res://share/en/moral.share",
		"text": "Morality is subjective",
		"debate": {
			"question": "Morality is subjective. I’ve got my truth.",
			"answer": "That sounds kind of dangerous, doesn’t it? You could literally justify any behavior by saying that. Animals want to live, and their perspective matters as well.",
		}
	}
]


# OTHER CONTROLS

const GO_BACK = "Go back"
const OOPS_TITLE = "Oops..."
const CONGRATULATIONS = "CONGRATS!"
const NOT_OWNED = "It seems that we cannot find your purchase.\n\nIf you purchased the product before, please email us at vegamescontact@gmail.com"
const NO_MORE_ADS = "It looks like our ad inventory is empty.\n\nPlease, try again in a few minutes."
const CANNOT_REACH = "It looks like we can't reach the server.\n\nPlease, check your Internet connection and try again in a few minutes."
const PURCHASE_SUCCESSFUL = "Your purchase was successful.\n\nYou can enjoy now the ad free version and its exclusive content."
const PURCHASE_UNSUCCESSFUL = "There was a problem while processing your purchase.\n\nYou can try again by tapping the upper-right button in the main screen."
const PURCHASE_UNSUCCESSFUL2 = "It seems we can't process your purchase request.\n\nTry again in a few minutes."
const PURCHASE_INSTRUCTIONS = "Your purchase was successful.\n\nNow you don't have to watch ads to earn broccoli. Instead, 2 exclusive minigames have been unlocked."
const PURCHASE_PRICE = "Get for "
const ALREADY_OWNED = "I already bought it"
const PROMOTION_MSG = "And discover new ways of getting broccoli without having to watch ads"

const SETTINGS_HEADER = "SETTINGS"
const SETTINGS_HEADER_SCALE = 1.0
const MUSIC_SETTINGS = "Music:"
const SOUND_SETTINGS = "Sound:"
const LANGUAGE_SETTINGS = "Language:"
const DELETE_PROGRESS_SETTINGS = "Delete progress"
const EXIT_GAME_SETTINGS = "Exit game"
const LOADING_LANGUAGE_SETTINGS = "Cargando idioma"
const MANAGE_ADS = "Ads"
const LOADING = "Loading"

const RESET_BOARD = "RESET BOARD?"
const RESET_BOARD_MSG = "The state of the board will be lost"

const EXIT_GAME = "EXIT GAME"
const EXIT_GAME_MSG = "Are you sure?"

const RESET_PROGRESS = "DELETE PROGRESS?"
const RESET_PROGRESS_MSG = "All the progress, including the board and records, will be permanently deleted.\n\nYou'll keep your broccolis."

const OFFLINE = "YOU APPEAR OFFLINE"
const OFFLINE_MSG = "Go online to earn broccoli and remove the tokens that are getting in your way!"

const EXCUSE_BOOK = "EXCUSES"
const EXCUSE_BOOK_LEGEND = "CURRENT MAXIMUM"
const EXCUSE_BOOK_NEW = "NEW"
const EXCUSE_BOOK_NEW_SCALE = 1.0
const EXCUSE_BOOK_TUTORIAL1 = "EXCUSE'S MEME"
const EXCUSE_BOOK_TUTORIAL2 = "REFUTATION"

const GAME_OVER = "GAME OVER"
const GAME_OVER_SCALE = 1.0
const GAME_OVER_MSG = "No more moves available"
const GAME_OVER_OR = "OR"
const GAME_OVER_QUESTION = "Watch a video ad to earn 3 broccolis?"
const GAME_OVER_QUESTION_AD_FREE = "\nPlay Broccoli Fiesta to earn broccolis.\n\nGOAL: Press the STOP button to instantly stop the wheel. Be careful, you have to be quick."
const GAME_OVER_PLAY_ROULETTE = "PLAY!"

const WIN1 = "YOU"
const WIN2 = "WON!"
const WIN_MSG_ANDROID = "You have completed the game! Now you can play to beat your own records.\n\nYou can support us by rating in Google Play or sharing with friends."
const WIN_MSG_IOS = "You have completed the game! Now you can play to beat your own records.\n\nYou can support us by rating in App Store or sharing with friends."
const IOS_SCORE_US = "RATE US"

const REWARDED_MSG = "Quack an offer!\n\nEarn 2 broccolis by watching an ad"
const DUCK_GAME_MSG = "Play Broccolitron to earn broccoli.\n\nGOAL: Stop each circle and try to place all broccolis in the highlighted region."

const BROCCOLI_INSTRUCTIONS = "Tap on a token to remove it"

const TAKE_A_LOOK = "AD-FREE VERSION"
const FIRST_ERROR9 = "We're getting no ads for you from the server.\n\nWe have given you a free broccoli so you can keep playing.\n\nYou can buy the Ad Free version to get exclusive content and earn broccolis without having to watch ads."
const ERROR9 = "We're getting no ads for you from the server.\n\n\nWe have given you one free broccoli so you can keep playing."

const NOT_EEA = "This functionality is only available in the EEA (European Economic Area)."

const RECORDS = "Records"
const RECORDS_TIME = "Time"
const RECORDS_USED_BROCCOLIS = "Used broccolis"
const RECORDS_NO_RECORDS = "No records yet.\n\nThis option will be available after completing the game."

const STOP = "Stop!"

const NEW_RECORD = "New Record!"
const INSTRUCTIONS_BUTTON = "How To Play"

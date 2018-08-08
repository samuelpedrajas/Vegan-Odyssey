extends Node


var language = "en"


var opening = [
	["B", "(lucy_salutes)(lau_happy_listening)Laura! Wow! (lau_salutes)It is a long-time no see! It is great to see you again."],
	["A", "(lucy_smiling)Lucy! (lau_happy_talking)What’s new? I’ve heard you’ve gone Vegan! Is that true(lau_happy_listening)?"],
	["B", "(lau_happy_listening)(lucy_happy)Yeah, that’s true. I really love animals so I decided to stop eating them(lucy_smiling)."],
	["A", "(lau_happy_talking)What? That doesn’t make any sense.(lucy_listening)(lau_proud)"],
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
		["B", "(lau_listening)(lucy_talking)Well, when talking about plants a lot of analogies with humans are made, but in reality they're just totally different than us."],
		["B", "They lack of central nervous systems and pain receptors. Neuroscientists say that pain is something created by a brain so... (lucy_happy)no brain, no pain."],
		["B", "(lucy_talking)Moreover, from an evolutionary point of view it makes no sense for plants to develop any feeling of pain. They're rooted, they don't run away from predators."],
		["B", "And... Did you know that you need 16 kg of plants to feed 1 kg of beef? (lucy_happy)So, if you're still interested in saving plants you've got to go vegan!"]
	], [
		["A", "(lau_talking)(lucy_listening)What you vegans don't understand is that (lau_finger)we need animal proteins to survive(lau_proud)."],
		["B", "(lau_listening)(lucy_happy)Well, do I look like a zombie to you? I'm sorry Laura, (lucy_talking)but that's a false statement. Humans don't need animal proteins to survive."],
		["B", "Whole grains, vegetables, and beans provide more than enough protein to stay healthy. It's very difficult to be protein-deficient when you get all calories you need."],
		["B", "(lucy_happy)You also can find many professional athletes in any sports that are vegan. They're a minority, yes, (lucy_talking)but vegans are also a minority in the global population."],
		["B", "Furthermore, all proteins ultimately come from plants. When you eat meat, (lucy_happy)you're getting proteins thanks to animals eating plants in the first place(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)I think humans eat meat because it's just how the circle of life works."],
		["B", "(lau_listening)(lucy_talking)Well, “circle of life” is just a term created to refer to the general tendency towards the equilibrium we can see in the animal kingdom, but it's not a law written on stone."],
		["B", "Keeping animals in cages with no chance to survive can't be part of any “circle of life”, neither can be genetically modifying them or having pieces of them in fridges."],
		["B", "It's entirely up to you to go vegan, no law is forcing you to stop or keep consuming animal products. That means you've got a decision to make(lucy_smiling)."]
	], [
		["A", "(lucy_smiling)(lau_serious_talking)Bacon, tho(lau_proud)(lucy_serious)."],
		["B", "Uhm... (lucy_stand_talking)I don't think you even deserve an answer but I'll ask you something:(lucy_talking_arm) do you support bull-fighting?(lucy_listening)"],
		["A", "(lau_finger)Absolutely not! That's animal abuse(lau_proud)."],
		["B", "(lucy_stand_talking)Well, bull-fighters say it's art. (lucy_talking)(lau_listening)They say they get pleasure for their eyes rather than their taste."],
		["B", "In both cases, personal pleasure is placed before animal welfare. I don't think that's a very honorable way of setting priorities(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)I eat meat because lions eat meat. If they can do it, why can't I?(lau_proud)"],
		["B", "(lucy_talking)Well, first of all, as far as we are aware you are not a lion... (lucy_happy)or are you? (lau_listening)"],
		["B", "(lucy_talking)In nature, lions often commit infanticide and, from a human perspective, other atrocities. What would you think if I picked any of these behaviors and said: “it's fine, lions do it”?"],
		["B", "They can't choose because of their nature, but we definitely can. We are very different than them, (lucy_happy)don't you think so?(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Cavemen ate meat, that's why I eat meat(lau_proud)."],
		["B", "(lucy_talking)Ha! Are you really going to justify your actions on “what would cavemen do”?(lau_listening) Are you doing this in the rest of your life decisions? Why use this for nutrition?"],
		["B", "Cavemen ate whatever they could find in their environment. Also, they were not 7.6 billion on the planet, so our circumstances as species have changed."],
		["B", "If it's health what concerns you, a vegan diet is perfectly suitable for your body even if you're a professional athlete. It's easy to find information about this(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Eating meat is legal, so what's the problem?(lau_listening) "],
		["B", "(lucy_talking)Well, there's one thing you should learn then: legal doesn't mean moral. Slavery in the form of people ownership was legal for almost all history of civilizations."],
		["B", "Also, not so long ago, women were not even persons in the eyes of legality. They were property of their husbands. This was legal, sure, but obviously not right."],
		["B", "Laws are written by humans and therefore are often wrong. This is why our ambition and will to improve must go beyond any law.(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Morality is subjective. You've got your truth, I've got my truth(lau_proud)."],
		["B", "(lucy_talking)That sounds kind of dangerous, doesn't it? (lau_listening)You could literally justify any behavior by saying that."],
		["B", "You need to come up with good arguments because when an animal is killed, is not only your subjectivity that matters. Animals want to live, their perspective also matters."],
		["B", "We're killing more than 60 billion land animals every year and this is having a catastrophic impact to our environment. Is there really any good justification to keep doing this(lucy_smiling)?"]
	]
]


var ending = [
	["A", "(lau_talking_open_eyes)(lucy_smiling)Well… Honestly, I never thought about it in that way."],
	["B", "(lucy_talking)(lau_happy_listening)Yeah, it’s something very attached to our culture, but that doesn’t make it right."],
	["A", "(lucy_smiling)(lau_talking_open_eyes)That makes sense. (lau_happy_talking)Thanks Lucy! You really make me think. (lau_talking_open_eyes)Veganism is much more important than I thought."],
	["B", "(lucy_happy)(lau_happy_listening)I’m glad to listen that! And the truth is that the sacrifice that you have to do to go vegan is very small in comparison with the good that you will be doing for the world."],
	["A", "(lucy_smiling)I see. (lau_happy_talking)I’ll keep all this in mind for the next time I go to the supermarket. (lau_salutes)Thanks again Lucy!(lucy_salutes)"]
]


# share
const TITLE = "Vegan Oddysey"
const SUBJECT = "Play Vegan Oddysey for iOS and Android."
const MSG = "Play Vegan Oddysey for iOS and Android. Download it for free at https://www.veganodysseythegame.com."


# excuse info
var EXCUSES = [
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
		"token_sprite": preload("res://images/excuses/circleoflife.png"),
		"book_sprite": preload("res://images/excuse_pictures/circleoflife.png"),
		"path": "res://share/circleoflife.share",
		"text": "Circle Of Life",
		"debate": {
			"question": "But isn’t it how the circle of life works?",
			"answer": "“Circle of life” is just a term we created to refer to the general tendency towards an equilibrium we can see in nature, but it’s not a law written on stone.",
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
	}
]


var tutorial_posts = {
	"1": "GOAL: JOIN ALL THE EXCUSES AND GET TO THE NINTH ONE!",
	"2": "TAP ON THE EXCUSE BOOK TO SEE DETAILS ABOUT YOUR UNLOCKED EXCUSES. C'MON, TAKE A LOOK!",
	"3": "WE ALL GET STUCK AT THE BEGINNING, LUCKY FOR YOU BROCCOLI EXISTS!",
	"4": "USE MAGIC BROCCOLI TO REMOVE TOKENS. YOU JUST HAVE TO TAP ON THEM!"
}

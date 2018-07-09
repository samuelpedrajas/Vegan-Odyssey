extends Node


var dialog_list = [
	[
		["A", "(lau_talking)(lucy_listening)What if you were in a deserted island?"],
		["B", "(lau_listening)(lucy_talking)Well, honestly I don't know. I hope I'm never in that situation. But what if you were in a civilization full of cruelty free options?"],
		["B", "You cannot justify your everyday actions on 'what would you do' in some extreme situation. That would be extreme, indeed.(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)But don't plants have feelings too?"],
		["B", "(lau_listening)(lucy_talking)Well, when talking about plants a lot of analogies with humans are made, but in reality they're just totally different than us."],
		["B", "They lack of central nervous systems and pain receptors. Neuroscientists say that pain is something created by a brain so... (lucy_happy)no brain, no pain."],
		["B", "(lucy_talking)Moreover, from an evolutionary point of view it makes no sense for plants to develop any feeling of pain. They're rooted, they don't run away from predators."],
		["B", "And... Did you know that you need 16 kg of plants to feed 1 kg of beef? (lucy_happy)So, if you're still interested in saving plants you've got to go vegan!"]
	], [
		["A", "(lau_talking)(lucy_listening)What you vegans don't understand is that (lau_finger)we need animal proteins to survive.(lau_proud)"],
		["B", "(lau_listening)(lucy_happy)Well, do I look like a zombie to you? I'm sorry A, (lucy_talking)but that's a false statement. Humans don't need animal proteins to survive."],
		["B", "Whole grains, vegetables, and beans provide more than enough protein to stay healthy. It's very difficult to be protein-deficient when you get all calories you need."],
		["B", "(lucy_happy)You also can find many professional athletes in any sports that are vegan. They're a minority, yes, (lucy_talking)but vegans are also a minority in the global population."],
		["B", "Furthermore, all proteins ultimately come from plants. When you eat meat, (lucy_happy)you're getting proteins thanks to animals eating plants in the first place.(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening) I think humans eat meat because it's just how the circle of life works."],
		["B", "(lau_listening)(lucy_talking)Well, 'circle of life' is just a term created to refer to the general tendency towards the equilibrium we can see in the animal kingdom, but it's not a law written on stone."],
		["B", "Keeping animals in cages with no chance to survive can't be part of any 'circle of life', neither can be genetically modifying them or having pieces of them in fridges."],
		["B", "It's entirely up to you to go vegan, no law is forcing you to stop or keep consuming animal products. That means you've got a decision to make.(lucy_smiling)"]
	], [
		["A", "(lau_serious_talking)Bacon, tho.(lau_proud)(lucy_serious)"],
		["B", "Uhm... (lucy_stand_talking)I don't think you even deserve an answer but I'll ask you something:(lucy_talking_arm) do you support bull-fighting?(lucy_listening)"],
		["A", "(lau_finger)Absolutely not! That's animal abuse.(lau_proud)"],
		["B", "(lucy_stand_talking)Well, bull-fighters say it's art. (lucy_talking)(lau_listening)They say they get pleasure for their eyes rather than their taste."],
		["B", "In both cases, personal pleasure is placed before animal welfare. I don't think that's a very honorable way of setting priorities.(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)I eat meat because lions eat meat. If they can do it, why can't I?(lau_proud)"],
		["B", "(lucy_talking)Well, first of all, as far as we are aware you are not a lion... (lucy_happy)or are you? (lau_listening)"],
		["B", "(lucy_talking)In nature, lions often commit infanticide and, from a human perspective, other atrocities. What would you think if I picked any of these behaviors and said: 'it's fine, lions do it'?"],
		["B", "They can't choose because of their nature, but we definitely can. We are very different than them, (lucy_happy)don't you think so?(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Cavemen ate meat, that's why I eat meat.(lau_proud)"],
		["B", "(lucy_talking)Ha! Are you really going to justify your actions on 'what would cavemen do'?(lau_listening) Are you doing this in the rest of your life decisions? Why use this for nutrition?"],
		["B", "Cavemen ate whatever they could find in their environment, that's why we're omnivores. Also, they were not 7.6 billion on the planet, so our circumstances as species have changed."],
		["B", "If it's health what concerns you, a vegan diet is perfectly suitable for your body even if you're a professional athlete. It's easy to find information about this.(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Eating meat is legal, so what's the problem?(lau_listening) "],
		["B", "(lucy_talking)Well, there's one thing you should learn then: legal doesn't mean moral. Slavery in the form of people ownership was legal for almost all history of civilizations."],
		["B", "Also, not so long ago, women were not even persons in the eyes of legality. They were property of their husbands. This was legal, sure, but obviously not right."],
		["B", "Laws are written by humans and therefore are often wrong. This is why our ambition and will to improve must go beyond any law."],
		["B", "Justice is a continuous improvement process because our reality is complex and we are not perfect. If we think otherwise, things will remain the same forever.(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Morality is subjective. You've got your truth, I've got my truth.(lau_proud)"],
		["B", "(lucy_talking)That sounds kind of dangerous, doesn't it? (lau_listening)You could literally justify any behavior by saying that."],
		["B", "You need to come up with good arguments because when an animal is killed, is not only your subjectivity that matters. Animals want to live, their perspective also matters."],
		["B", "We're killing more than 60 billion land animals every year and this is having a catastrophic impact to our environment. Is there really any good justification to keep doing this?(lucy_smiling)"]
	]
]
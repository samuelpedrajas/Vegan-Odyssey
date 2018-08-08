extends Node


var opening = [
	["B", "(lucy_salutes)(lau_happy_listening)¡Laura! (lau_salutes)¡Cuánto tiempo! Que alegría volver a verte."],
	["A", "(lucy_smiling)¡Lucía! (lau_happy_talking)¿Cómo te va todo? Me enteré de que te hiciste vegana, ¿es eso cierto?"],
	["B", "(lau_happy_listening)(lucy_happy)Así es. Me gustan mucho los animales, así que decidí dejar de comérmelos(lucy_smiling)."],
	["A", "(lau_happy_talking)¿Cómo? Eso no tiene ningún sentido.(lucy_listening)(lau_proud)"],
	["B", "(lucy_stand_talking)¿Por qué?(lucy_listening)"],
	["A", "(lau_finger)Porque... ¿Y (music)SI ESTUVIESES EN UNA ISLA DESIERTA(lau_proud)(lucy_serious)?"]
]


var dialog_list = [
	[
		["A", "(lau_talking)(lucy_listening)¿Y si estuvieses en una isla desierta?"],
		["B", "(lau_listening)(lucy_talking)Bueno, la verdad es que no sé qué decirte, espero no estar nunca en esa situación. Pero... ¿Has pensado en qué harías tú si estuvieses en una civilización llena de opciones libres de crueldad animal?"],
		["B", "No creo que sea muy sabio decidir qué hacer en tus acciones cotidianas basándote en lo que harías si estuvieses en alguna situación extrema. Eso sería, precisamente, extremo.(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Pero las plantas también sienten ¿no?"],
		["B", "(lau_listening)(lucy_talking)Bueno, lo cierto es que cuando se habla de plantas se suelen hacer muchas analogías con los humanos, pero la realidad es que somos totalmente diferentes."],
		["B", "Las plantas no tienen sistema nervioso centralizado, el cual según la ciencia actual, es el único que puede proporcionar a un ser de sentido del dolor entre muchos otros. No es que puedan sentir, simplemente reaccionan a estimulos de manera inconsciente."],
		["B", "(lucy_talking)Además, desde un punto de vista evolutivo no tiene ningún sentido que las plantas pudiesen sentir dolor como nosotros. Ellas están ancladas al suelo, no pueden huir de depredadores."],
		["B", "Y por cierto... ¿Sabias que necesitas 16kg de plantas para conseguir 1 solo kg de carne? (lucy_happy)Así que si por casualidad sigues interesada en salvar plantas, deberías hacerte vegana igualmente"]
	], [
		["A", "(lau_talking)(lucy_listening)Lo que los veganos no entendéis es que (lau_finger)necesitamos proteína animal para sobrevivir(lau_proud)."],
		["B", "(lau_listening)(lucy_happy)¿Te crees que soy un zombie yo o qué? Lo siento Laura, (lucy_talking)pero eso es totalmente mentira. Los humanos no necesitamos proteína animal para sobrevivir."],
		["B", "Cereales, vegetales y legumbres nos proporcionan una cantidad más que suficiente de proteínas para mantenernos completamente sanos. Es muy difícil tener déficit de proteínas siempre que consumas las calorías que necesitas."]
	], [
		["A", "(lau_talking)(lucy_listening)Creo que las personas comemos carne porque es parte del ciclo de la vida."],
		["B", "(lau_listening)(lucy_talking)En realidad \"ciclo de la vida\" es solo un termino creado para describir la tendencia al equilibrio que podemos ver en la naturaleza, pero no es una ley escrita en piedra."],
		["B", "Encerrar a animales en jaulas sin posibilidad de sobrevivir no puede ser parte de ningún "ciclo de la vida", y aún menos modificarlos genéticamente o tener trozos de ellos en nuestra nevera."],
		["B", "La decisión de hacerte vegano es solamente tuya, nada ni nadie te está obligando a parar o seguir consumiendo productos animales.(lucy_smiling)."]
	], [
		["A", "(lucy_smiling)(lau_serious_talking)Mmmmh...Bacon(lau_proud)(lucy_serious)."],
		["B", "Emm... (lucy_stand_talking)No se si eso merece una respuesta, pero te voy a preguntar algo:(lucy_talking_arm) ¿Estás a favor de la tauromaquia?(lucy_listening)"],
		["A", "(lau_finger)¡Claro que no! Eso es abuso animal(lau_proud)."],
		["B", "(lucy_stand_talking)Pues lo cierto es que los amantes de la tauromaquia dicen que es arte(lucy_talking)(lau_listening)y que como tal, les proporciona placer a través de los ojos, en lugar de a través del gusto."],
		["B", "En ambos casos, el placer personal se pone por delante del bienestar animal, lo cual no me parece una forma muy honorífica de establecer prioridades(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Como carne por la misma razón que los leones comen carne. Si ellos lo hacen, ¿por qué yo no puedo?(lau_proud)"],
		["B", "(lucy_talking)Bueno, antes que nada, tu no eres un león...¿no? (lucy_happy)(lau_listening)"],
		["B", "(lucy_talking)En la naturaleza, los leones cometen infanticidio y desde una perspectiva humana muchas otras atrocidades. Que pensarías si empezase a hacer cualquiera de estas cosas y dijese que no pasa nada porque los leones también lo hacen?"],
		["B", "Ellos no pueden escoger por su naturaleza, pero nosotros si que podemos. Por lo que somos muy diferentes a ellos, (lucy_happy)¿no crees?(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Pero los cavernícolas ya comían carne.(lau_proud)."],
		["B", "(lucy_talking)¿Enserio vas a justificar tus acciones según lo que los cavernícolas hacían o dejaban de hacer?(lau_listening) ¿Haces eso con el resto de decisiones de tu vida? ¿Entonces por qué vas a hacerlo con tu nutrición?"],
		["B", "Los cavernícolas comían todo lo que encontraban en su entorno. Además, que ellos no eran 7.6 mil millones de personas en el planeta, por lo que las circunstancias como especie han cambiado bastante."],
		["B", "Pero si es la salud lo que te preocupa, que sepas que una dieta vegana es completamente recomendable incluso si eres un atleta profesional. Tienes mucha información al respecto, si estas interesada.(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Pero comer carne es legal. (lau_listening) "],
		["B", "(lucy_talking)Hay una cosa que debes saber, y es que legal no quiere decir moral. La esclavitud como forma de propiedad humana ha sido legal durante casi toda la historia de la civilización."],
		["B", "También, no hace mucho tiempo, las mujeres no éramos personas ante la ley, sino propiedad de nuestros maridos, lo cual era totalmente legal pero obviamente no era justo ni moral."],
		["B", "Las leyes están escritas por personas, por lo que muchas veces están equivocadas. Y eso es por lo que nuestra ambición de querer mejorar tiene que estar por encima de cualquier ley.(lucy_smiling)"]
		
	], [
		["A", "(lau_talking)(lucy_listening)Pero la moralidad es subjetiva, tu tienes tu verdad y yo tengo la mía(lau_proud)."],
		["B", "(lucy_talking)¿No te suena eso un poco peligroso? (lau_listening)Podrías justificar absolutamente cualquier cosa diciendo eso."],
		["B", "Lo cierto es que necesitas muy buenos argumentos para justificar la matanza de un animal, ya que no es solo tu perspectiva la que importa, hay que tener en cuenta que los animales tienen sus propios intereses y quieren vivir, por lo que no cualquier argumento basta."],
		["B", "Estamos matando mas de 60 mil millones de animales al año lo cual esta teniendo un impacto catastrófico en nuestro medio ambiente. ¿De verdad crees que hay alguna justificación razonable para ello(lucy_smiling)?"]
	]
]

var ending = [
	["A", "(lau_talking_open_eyes)(lucy_smiling)Pues... La verdad es que nunca lo había pensado así."],
	["B", "(lucy_talking)(lau_happy_listening)Ya, es que es algo muy arraigado a nuestra cultura, pero eso no lo hace correcto."],
	["A", "(lucy_smiling)(lau_talking_open_eyes)Tienes razón. (lau_happy_talking)¡Gracias Lucía! He aprendido mucho. (lau_talking_open_eyes)El Veganismo es mucho mas importante de lo que creía."],
	["B", "(lucy_happy)(lau_happy_listening)¡Me alegro de oír eso! Y lo curioso es que al final el sacrificio que tienes que hacer por ser vegana es insignificante si lo comparas con todo el bien que haces al mundo."],
	["A", "(lucy_smiling)Ya veo. (lau_happy_talking)Te aseguro que tendré todo esto en mente la próxima vez que vaya al supermercado. (lau_salutes)Gracias de nuevo Lucía, hasta pronto!(lucy_salutes)"]
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

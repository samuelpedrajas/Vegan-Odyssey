extends Node


var language = "es"


var opening = [
	["B", "(lucy_salutes)(lau_happy_listening)¡Laura! (lau_salutes)¡Cuánto tiempo! Que alegría volver a verte."],
	["A", "(lucy_smiling)¡Lucía! (lau_happy_talking)¿Cómo te va todo? Me enteré de que te hiciste vegana, ¿es eso cierto?"],
	["B", "(lau_happy_listening)(lucy_happy)Así es. Me gustan mucho los animales, así que decidí dejar de comérmelos(lucy_smiling)."],
	["A", "(lau_happy_talking)¿Cómo? Eso no tiene ningún sentido(lucy_listening)(lau_proud)."],
	["B", "(lucy_stand_talking)¿Por qué?(lucy_listening)"],
	["A", "(lau_finger)Porque... ¿Y (music)SI ESTUVIESES EN UNA ISLA DESIERTA(lau_proud)(lucy_serious)?"]
]


var dialog_list = [
	[
		["A", "(lau_talking)(lucy_listening)¿Y si estuvieses en una isla desierta?"],
		["B", "(lau_listening)(lucy_talking)Bueno, la verdad es que no sé qué decirte, espero no estar nunca en esa situación. Pero... ¿Has pensado en qué harías tú si estuvieses en una civilización llena de opciones libres de crueldad animal?"],
		["B", "No creo que sea muy sabio decidir qué hacer en tus acciones cotidianas basándote en lo que harías si estuvieses en alguna situación extrema. Eso sería, precisamente, extremo(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Pero las plantas también sienten ¿no?"],
		["B", "(lau_listening)(lucy_talking)Bueno, lo cierto es que cuando se habla de plantas se suelen hacer muchas analogías con los humanos, pero la realidad es que somos totalmente diferentes."],
		["B", "Las plantas no tienen sistema nervioso centralizado, el cual según la ciencia actual, es el único que puede proporcionar a un ser de sentido del dolor entre muchos otros. No es que puedan sentir, simplemente reaccionan a estimulos de manera inconsciente."],
		["B", "Y por cierto... ¿Sabias que necesitas 16kg de plantas para conseguir 1 solo kg de carne? (lucy_happy)Así que si por casualidad sigues interesada en salvar plantas, deberías hacerte vegana igualmente."]
	], [
		["A", "(lau_talking)(lucy_listening)Lo que los veganos no entendéis es que (lau_finger)necesitamos proteína animal para sobrevivir(lau_proud)."],
		["B", "(lau_listening)(lucy_happy)¿Te crees que soy un zombie yo o qué? Lo siento Laura, (lucy_talking)pero eso es totalmente mentira. Los humanos no necesitamos proteína animal para sobrevivir."],
		["B", "Cereales, vegetales y legumbres nos proporcionan una cantidad más que suficiente de proteínas para mantenernos completamente sanos. Es muy difícil tener déficit de proteínas siempre que consumas las calorías que necesitas."]
	], [
		["A", "(lau_talking)(lucy_listening)Creo que las personas comemos carne porque es parte del ciclo de la vida."],
		["B", "(lau_listening)(lucy_talking)En realidad \"ciclo de la vida\" es solo un termino creado para describir la tendencia al equilibrio que podemos ver en la naturaleza, pero no es una ley escrita en piedra."],
		["B", "Encerrar animales en jaulas sin posibilidad de sobrevivir no puede ser parte de ningún “ciclo de la vida”, y aún menos modificarlos genéticamente o tener trozos de ellos en nuestra nevera."],
		["B", "La decisión de hacerte vegano es solamente tuya, nada ni nadie te está obligando a parar o seguir consumiendo productos animales(lucy_smiling)."]
	], [
		["A", "(lucy_smiling)(lau_serious_talking)Mmhh... Bacon(lau_proud)(lucy_serious)."],
		["B", "Emm... (lucy_stand_talking)No se si eso merece una respuesta, pero te voy a preguntar algo:(lucy_talking_arm) ¿Estás a favor de la tauromaquia?(lucy_listening)"],
		["A", "(lau_finger)¡Claro que no! Eso es abuso animal(lau_proud)."],
		["B", "(lucy_stand_talking)Pues lo cierto es que los amantes de la tauromaquia dicen que es arte(lucy_talking)(lau_listening) y que como tal, les proporciona placer a través de los ojos, en lugar de a través del gusto."],
		["B", "En ambos casos, el placer personal se pone por delante del bienestar animal, lo cual no me parece una forma muy honorífica de establecer prioridades(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Como carne por la misma razón que los leones comen carne. Si ellos lo hacen, ¿por qué yo no puedo?(lau_proud)"],
		["B", "(lucy_talking)Bueno, antes que nada, tu no eres un león...¿no? (lucy_happy)(lau_listening)"],
		["B", "(lucy_talking)En la naturaleza, los leones cometen infanticidio y desde una perspectiva humana muchas otras atrocidades. ¿Qué pensarías si empezase a hacer cualquiera de estas cosas y dijese que no pasa nada porque los leones también lo hacen?"],
		["B", "Ellos no pueden escoger por su naturaleza, pero nosotros si que podemos. Por lo que somos muy diferentes a ellos, (lucy_happy)¿no crees?(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Pero los cavernícolas ya comían carne(lau_proud)."],
		["B", "(lucy_talking)¿Enserio vas a justificar tus acciones según lo que los cavernícolas hacían o dejaban de hacer?(lau_listening) ¿Haces eso con el resto de decisiones de tu vida? ¿Entonces por qué vas a hacerlo con tu nutrición?"],
		["B", "Los cavernícolas comían todo lo que encontraban en su entorno. Además, que ellos no eran 7.6 mil millones de personas en el planeta, por lo que las circunstancias como especie han cambiado bastante."],
		["B", "Pero si es la salud lo que te preocupa, que sepas que una dieta vegana es completamente recomendable incluso si eres un atleta profesional. Tienes mucha información al respecto si estás interesada(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Pero comer carne es legal. (lau_listening) "],
		["B", "(lucy_talking)Hay una cosa que debes saber, y es que legal no quiere decir moral. La esclavitud como forma de propiedad humana ha sido legal durante casi toda la historia de la civilización."],
		["B", "También, no hace mucho tiempo, las mujeres no éramos personas ante la ley, sino propiedad de nuestros maridos, lo cual era totalmente legal pero obviamente injusto e inmoral."],
		["B", "Las leyes están escritas por personas, por lo que muchas veces están equivocadas. Y eso es por lo que nuestra ambición de querer mejorar tiene que estar por encima de cualquier ley(lucy_smiling)."]
		
	], [
		["A", "(lau_talking)(lucy_listening)Pero la moralidad es subjetiva, tu tienes tu verdad y yo tengo la mía(lau_proud)."],
		["B", "(lucy_talking)¿No te suena eso un poco peligroso? (lau_listening)Podrías justificar absolutamente cualquier cosa diciendo eso."],
		["B", "Lo cierto es que necesitas muy buenos argumentos para justificar la matanza de un animal, ya que no es solo tu perspectiva la que importa, hay que tener en cuenta que los animales tienen sus propios intereses y quieren vivir, por lo que no cualquier argumento basta."],
		["B", "Estamos matando mas de 60 mil millones animales al año, lo cual esta teniendo un impacto catastrófico en nuestro medio ambiente. ¿De verdad crees que hay alguna justificación razonable para ello(lucy_smiling)?"]
	]
]

var ending = [
	["A", "(lau_talking_open_eyes)(lucy_smiling)Pues... La verdad es que nunca lo había pensado así."],
	["B", "(lucy_talking)(lau_happy_listening)Ya, es que es algo muy arraigado a nuestra cultura, pero eso no lo hace correcto."],
	["A", "(lucy_smiling)(lau_talking_open_eyes)Tienes razón. (lau_happy_talking)¡Gracias Lucía! He aprendido mucho. (lau_talking_open_eyes)El Veganismo es mucho mas importante de lo que creía."],
	["B", "(lucy_happy)(lau_happy_listening)¡Me alegro de oír eso! Y lo curioso es que al final el sacrificio que tienes que hacer por ser vegana es insignificante si lo comparas con todo el bien que haces al mundo."],
	["A", "(lucy_smiling)Ya veo. (lau_happy_talking)Te aseguro que tendré todo esto en mente la próxima vez que vaya al supermercado. (lau_salutes)Gracias de nuevo Lucía, ¡hasta pronto!(lucy_salutes)"]
]


# share
const TITLE = "Vegan Odyssey"
const SUBJECT = "Juega a Vegan Odyssey en iOS y Android"
const MSG = "Juega a Vegan Odyssey en iOS y Android. Descárgalo ahora gratis en https://www.veganodysseythegame.com/es"


# excuse info
var EXCUSES = [
	{
		"token_sprite": preload("res://images/excuses/es/desertedisland.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/desertedisland.png"),
		"path": "res://share/es/desertedisland.share",
		"text": "Isla desierta",
		"debate": {
			"question": "¿Y si estuvieses en una isla desierta?",
			"answer": "¿Y si estuvieses en una civilización llena de opciones libres de crueldad? No puedes justificar tus acciones diarias con lo que harías en alguna situación extrema.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/es/plantshavefeelings.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/plantshavefeelings.png"),
		"path": "res://share/es/plantshavefeelings.share",
		"text": "Las plantas sienten",
		"debate": {
			"question": "Pero las plantas también sienten ¿no?",
			"answer": "No. Las plantas no tienen sistema nervioso centralizado, el cual según la ciencia actual, es el único que puede proporcionar a un ser de sentido del dolor.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/es/proteins.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/proteins.png"),
		"path": "res://share/es/proteins.share",
		"text": "Proteínas",
		"debate": {
			"question": "Pero necesitamos proteína animal.",
			"answer": "Cereales, verduras y legumbres proporcionan toda la proteína que necesitas. Es difícil tener deficiencia de proteínas si consumes todas las calorías que necesitas. ",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/es/circleoflife.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/circleoflife.png"),
		"path": "res://share/es/circleoflife.share",
		"text": "Ciclo de la vida",
		"debate": {
			"question": "Es parte del ciclo de la vida.",
			"answer": "“Ciclo de la vida” es sólo un término que inventamos para referirnos al equilibrio que podemos ver en la naturaleza. No es ninguna ley escrita en piedra.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/bacon.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/bacon.png"),
		"path": "res://share/es/bacon.share",
		"text": "Mmhh... Bacon",
		"debate": {
			"question": "Mmhh... Bacon.",
			"answer": "Venga va. Eso no es ni siquiera un argumento. Una conciencia limpia sabe mejor que el mejor bacon del mundo, ¿no crees?",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/es/lions.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/lions.png"),
		"path": "res://share/es/lions.share",
		"text": "Leones",
		"debate": {
			"question": "Los leones comen carne, ¿no?",
			"answer": "Lo hacen. Pero en la naturaleza los leones también cometen muchas atrocidades. ¿Qué pensarías si yo imitase alguna de ellas y dijese “los leones también lo hacen”?",
		}
	}, {
		"token_sprite": preload("res://images/excuses/es/caveman.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/caveman.png"),
		"path": "res://share/es/caveman.share",
		"text": "Cavernícolas",
		"debate": {
			"question": "Yo como carne como los cavernícolas.",
			"answer": "¿De verdad basas tus acciones diarias en cómo vivían los cavernícolas? ¿Haces esto en el resto de tus decisiones? ¿O sólo cuando se trata de nutrición?",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/es/legal.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/legal.png"),
		"path": "res://share/es/legal.share",
		"text": "Es legal",
		"debate": {
			"question": "Comer carne es legal.",
			"answer": "Legal no significa moral. Poseer personas como si de propiedades se tratasen ha sido legal durante casi toda la historia. Apelar a la legalidad no es suficiente.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/es/moral.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/moral.png"),
		"path": "res://share/es/moral.share",
		"text": "Subjetividad moral",
		"debate": {
			"question": "La moral es subjetiva. Yo tengo mi verdad.",
			"answer": "Uy… Eso suena un poco peligroso, ¿no? Podrías justificar cualquier cosa diciendo eso. Los animales también quieren vivir y eso se tiene que tener en cuenta.",
		}
	}
]


var tutorial_posts = {
	"1": "OBJETIVO: JUNTA LAS EXCUSAS IGUALES HASTA LLEGAR A LA NOVENA",
	"2": "LAS EXCUSAS DESBLOQUEADAS SE GUARDAN EN EL LIBRO DE EXCUSAS. VAMOS, ¡HECHA UN VISTAZO!",
	"3": "A TODOS NOS CUESTA UN POCO AL PRINCIPIO, ¡QUE SUERTE QUE EL BROCOLI EXISTA!",
	"4": "USA EL BROCOLI MÁGICO PARA QUITAR FICHAS. SÓLO TIENES QUE PULSAR SOBRE ELLAS"
}


# OTHER CONTROLS

const GO_BACK = "Volver"
const NO_MORE_ADS_TITLE = "¡VAYA!"
const NO_MORE_ADS = "Parece que no hay más anuncios disponibles.\n\nPrueba de nuevo en unos minutos."
const LOADING_AD = "Cargando anuncio"

const SETTINGS_HEADER = "CONFIGURACIÓN"
const SETTINGS_HEADER_SCALE = 0.65
const MUSIC_SETTINGS = "Música:"
const SOUND_SETTINGS = "Sonido:"
const LANGUAGE_SETTINGS = "Idioma:"
const DELETE_PROGRESS_SETTINGS = "Borrar progreso"
const EXIT_GAME_SETTINGS = "Salir del juego"
const LOADING_LANGUAGE_SETTINGS = "Loading language"

const RESET_BOARD = "¿REINICIAR TABLERO?"
const RESET_BOARD_MSG = "El estado actual del tablero se perderá"

const EXIT_GAME = "SALIR DEL JUEGO"
const EXIT_GAME_MSG = "¿Estás seguro?"

const RESET_PROGRESS = "¿BORRAR PROGRESO?"
const RESET_PROGRESS_MSG = "Todo el progreso incluyendo el tablero actual será permanentemente borrado.\n\nNo perderás tus broccolis."

const OFFLINE = "SIN CONEXIÓN"
const OFFLINE_MSG = "Conéctate a Internet para conseguir brócoli y apoyarnos.\n\nActualmente los anuncios son nuestra única forma de poder hacer juegos como este."

const EXCUSE_BOOK = "EXCUSAS"
const EXCUSE_BOOK_LEGEND = "MÁXIMA ACTUAL"
const EXCUSE_BOOK_NEW = "NUEVO"
const EXCUSE_BOOK_NEW_SCALE = 0.8

const GAME_OVER = "HAS PERDIDO"
const GAME_OVER_SCALE = 0.8
const GAME_OVER_MSG = "No quedan movimientos disponibles"
const GAME_OVER_OR = "O"

const WIN1 = "¡HAS"
const WIN2 = "GANADO!"
const WIN_MSG = "¡Felicidades! Has completado el juego. Puedes apoyarnos puntuando en Play Store o compartiendo con tus amigos."

const REWARDED_MSG = "¡Consigue brócolis con el poder del marketing!"

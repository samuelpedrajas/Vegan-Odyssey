extends Node


const language = "es"


var opening = [
	["B", "(lucy_salutes)(lau_happy_listening)¡Laura! (lau_salutes)¡Cuánto tiempo! Qué alegría volver a verte."],
	["A", "(lucy_smiling)¡Lucía! (lau_happy_talking)¿Cómo te va todo? He oído que te has hecho vegana, ¿es eso cierto?"],
	["B", "(lau_happy_listening)(lucy_happy)Así es. Investigué sobre el tema y descubrí que se puede vivir perfectamente sin comer ni usar animales.(lucy_smiling)"],
	["A", "(lau_happy_talking)¿Cómo? Eso no tiene ningún sentido(lucy_listening)(lau_proud)."],
	["B", "(lucy_stand_talking)¿Por qué?(lucy_listening)"],
	["A", "(lau_finger)Porque... ¿Y (music)SI ESTUVIESES EN UNA ISLA DESIERTA(lau_proud)(lucy_serious)?"]
]


var dialog_list = [
	[
		["A", "(lau_talking)(lucy_listening)¿Y si estuvieses en una isla desierta?"],
		["B", "(lau_listening)(lucy_talking)Bueno, la verdad es que no sé qué decirte, espero no estar nunca en esa situación. Pero..."],
		["B", "¿Has pensado en qué harías tú si estuvieses en una civilización llena de opciones libres de crueldad animal?"],
		["B", "No me parece razonable decidir tus acciones cotidianas basándote en qué harías si estuvieses en alguna situación extrema. Eso sería, precisamente, extremo(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Pero las plantas también sienten, ¿no?"],
		["B", "(lau_listening)(lucy_talking)Bueno, cuando se habla de plantas se suelen hacer muchas analogías con los humanos. Pero la realidad es que somos totalmente diferentes."],
		["B", "Las plantas carecen de sistema nervioso centralizado que, según la neurociencia actual, es lo que nos proporciona la capacidad de sentir conscientemente."],
		["B", "Y por cierto... ¿Sabías que necesitas 16 kg de plantas para conseguir 1 kg de carne? (lucy_happy)Así que si sigues interesada en salvar plantas, ¡deberías hacerte vegana(lucy_smiling)!"]
	], [
		["A", "(lau_talking)(lucy_listening)Lo que los veganos no entendéis es que (lau_finger)necesitamos la proteína animal para sobrevivir(lau_proud)."],
		["B", "(lau_listening)(lucy_happy)¿Te crees que soy un zombie o qué? Lo siento Laura, (lucy_talking)pero eso no es verdad. Los humanos no necesitamos proteína animal para sobrevivir."],
		["B", "Cereales, vegetales y legumbres nos proporcionan una cantidad más que suficiente de proteínas para mantenernos completamente sanos."],
		["B", "Es muy difícil tener déficit de proteínas si consumes las calorías que necesitas."],
		["B", "(lucy_happy)También puedes encontrar atletas profesionales veganos. (lucy_talking)Son una minoría, sí, pero también lo son en la población global(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Creo que las personas comemos carne porque es parte del “ciclo de la vida”."],
		["B", "(lau_listening)(lucy_talking)“El ciclo de la vida” es sólo un término creado para referirnos a cierto equilibrio que vemos en la naturaleza, pero no es una ley escrita en piedra."],
		["B", "Encerrar animales en jaulas sin posibilidad de salir no puede ser parte de ningún “ciclo de la vida”, y aún menos modificarlos genéticamente o tener trozos de ellos en nuestra nevera."],
		["B", "La decisión de hacerte vegano es solamente tuya. Ninguna ley natural te está obligando a seguir consumiendo productos animales(lucy_smiling)."]
	], [
		["A", "(lucy_smiling)(lau_serious_talking)Mmhh... Bacon(lau_proud)(lucy_serious)."],
		["B", "Ehm... (lucy_stand_talking)No sé si eso merece una respuesta pero... Te voy a preguntar algo:(lucy_talking_arm) ¿estás a favor de la tauromaquia?(lucy_listening)"],
		["A", "(lau_finger)¡Claro que no! Eso es abuso animal(lau_proud)."],
		["B", "(lucy_stand_talking)Pues lo cierto es que los amantes de la tauromaquia dicen que es arte(lucy_talking)(lau_listening) y que, como tal, les proporciona placer a través de la vista en lugar del gusto."],
		["B", "En ambos casos, el placer personal se pone por delante del bienestar animal, lo cual no me parece una forma muy responsable de establecer prioridades(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Como carne porque los leones comen carne. Si ellos lo hacen, ¿por qué yo no puedo?(lau_proud)"],
		["B", "(lucy_talking)Bueno, antes que nada, tú no eres un león... ¿No? (lucy_happy)(lau_listening)"],
		["B", "(lucy_talking)Los leones cometen infanticidio y otras atrocidades desde una perspectiva humana. ¿Qué pensarías si imitase alguna de estas cosas y la justificase con “los leones también lo hacen”?"],
		["B", "Su naturaleza limita sus opciones, pero no es nuestro caso. Somos muy diferentes a ellos, (lucy_happy)¿no crees?(lucy_smiling)"]
	], [
		["A", "(lau_talking)(lucy_listening)Pero los cavernícolas comían carne(lau_proud)."],
		["B", "(lucy_talking)¿De verdad vas a justificar tus acciones basándote en lo que hacían los cavernícolas?(lau_listening) ¿Haces eso con el resto de decisiones? ¿Por qué hacerlo con tu nutrición?"],
		["B", "Los cavernícolas comían lo que encontraban en su entorno. Además, ellos no eran 7.6 mil millones en el planeta. Nuestras circunstancias como especie han cambiado."],
		["B", "Si es la salud lo que te preocupa, una dieta vegana es muy recomendable incluso si eres un atleta profesional. Hay mucha información al respecto(lucy_smiling)."]
	], [
		["A", "(lau_talking)(lucy_listening)Comer carne es legal. (lau_listening) "],
		["B", "(lucy_talking)Hay una cosa que debes saber y es que legal no quiere decir ético. La esclavitud ha sido legal durante casi toda la historia de la civilización."],
		["B", "También, no hace mucho tiempo, las mujeres no éramos personas ante la ley. Éramos propiedad de nuestros maridos, lo cual era legal pero obviamente injusto e inmoral."],
		["B", "Las leyes las escriben personas, por lo que muchas veces son erróneas. Por ello, nuestra ambición de querer mejorar tiene que estar por encima de cualquier ley(lucy_smiling)."]
		
	], [
		["A", "(lau_talking)(lucy_listening)La moralidad es subjetiva, tú tienes tu verdad y yo tengo la mía(lau_proud)."],
		["B", "(lucy_talking)Eso suena un poco peligroso, ¿no? (lau_listening)Podrías justificar cualquier cosa diciendo eso."],
		["B", "Lo cierto es que necesitas muy buenos argumentos para matar intencionadamente a un animal ya que no es sólo tu perspectiva la que importa."],
		["B", "Los animales también tienen sus propios intereses y quieren vivir. No puedes ignorar eso si pretendes ser justa."],
		["B", "Matamos más de 60 mil millones de animales al año, lo cual impacta catastróficamente en nuestro medio ambiente. ¿De verdad hay alguna justificación razonable para esto(lucy_smiling)?"]
	]
]

var ending = [
	["A", "(lau_talking_open_eyes)(lucy_smiling)Pues... La verdad es que nunca lo había pensado así."],
	["B", "(lucy_talking)(lau_happy_listening)Es que es algo muy arraigado a nuestra cultura, pero eso no lo convierte en correcto."],
	["A", "(lucy_smiling)(lau_talking_open_eyes)Tienes razón. (lau_happy_talking)¡Gracias Lucía! He aprendido mucho. (lau_talking_open_eyes)El veganismo es mucho más importante de lo que creía."],
	["B", "(lucy_happy)(lau_happy_listening)¡Me alegra oír eso! Y lo curioso es que al final el sacrificio que tienes que hacer es insignificante comparado con el bien que haces al mundo."],
	["A", "(lucy_smiling)Ya veo. (lau_happy_talking)Tendré todo esto en mente la próxima vez que vaya al supermercado. (lau_salutes)Gracias de nuevo Lucía, ¡hasta pronto!(lucy_salutes)"]
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
			"question": "Pero las plantas también sienten, ¿no?",
			"answer": "No. Según la neurociencia actual se requiere de un sistema nervioso centralizado para sentir conscientemente, y las plantas carecen de él.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/es/proteins.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/proteins.png"),
		"path": "res://share/es/proteins.share",
		"text": "Proteínas",
		"debate": {
			"question": "Pero necesitamos la proteína animal.",
			"answer": "Cereales, verduras y legumbres tienen toda la proteína que necesitas. Es difícil tener déficit de proteínas si consumes todas las calorías que necesitas.",
		}
	},
	{
		"token_sprite": preload("res://images/excuses/es/circleoflife.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/circleoflife.png"),
		"path": "res://share/es/circleoflife.share",
		"text": "Ciclo de la vida",
		"debate": {
			"question": "Es parte del “ciclo de la vida”.",
			"answer": "“Ciclo de la vida” es sólo un término que inventamos para referirnos a cierto equilibrio que vemos en la naturaleza, pero no es una ley escrita en piedra.",
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
			"question": "Pero los leones comen carne, ¿no?",
			"answer": "Sí, pero los leones también cometen muchas atrocidades. ¿Qué pensarías si yo imitase alguna de ellas y lo justificase con “los leones también lo hacen”?",
		}
	}, {
		"token_sprite": preload("res://images/excuses/es/caveman.png"),
		"book_sprite": preload("res://images/excuse_pictures/es/caveman.png"),
		"path": "res://share/es/caveman.share",
		"text": "Cavernícolas",
		"debate": {
			"question": "Como carne como los cavernícolas.",
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
			"answer": "Legal no significa ético. Poseer personas como propiedad también ha sido legal durante casi toda la historia. Apelar a la legalidad no es suficiente.",
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


# OTHER CONTROLS

const GO_BACK = "Volver"
const OOPS_TITLE = "¡VAYA!"
const CONGRATULATIONS = "¡FELICIDADES!"
const NOT_OWNED = "Parece que no podemos verificar tu compra.\n\nSi has comprado el producto antes, envíanos un e-mail a vegamescontact@gmail.com"
const NO_MORE_ADS = "Parece que no hay más anuncios disponibles.\n\nPrueba de nuevo en unos minutos."
const CANNOT_REACH = "Parece que no podemos conectarnos con el servidor.\n\nComprueba tu conexión a Internet e inténtalo de nuevo en unos minutos."
const PURCHASE_SUCCESSFUL = "Tu compra ha sido realizada con éxito.\n\nAhora puedes disfrutar de la versión sin anuncios y de su contenido exclusivo."
const PURCHASE_UNSUCCESSFUL = "Ha habido un problema durante la compra.\n\nInténtalo de nuevo desde la esquina superior derecha de la pantalla principal."
const PURCHASE_UNSUCCESSFUL2 = "Parece que tenemos algún problema para efectuar tu compra.\n\nInténtalo de nuevo en unos minutos."
const PURCHASE_INSTRUCTIONS = "Tu compra ha sido realizada con éxito.\n\nYa no necesitas ver anuncios para conseguir brócoli. En su lugar, 2 minijuegos exclusivos han sido desbloqueados."
const PURCHASE_PRICE = "Obtener por "
const ALREADY_OWNED = "Ya lo he comprado"
const PROMOTION_MSG = "Y descubre nuevas formas de conseguir brócoli sin tener que ver anuncios"

const SETTINGS_HEADER = "CONFIGURACIÓN"
const SETTINGS_HEADER_SCALE = 0.75
const MUSIC_SETTINGS = "Música:"
const SOUND_SETTINGS = "Sonido:"
const LANGUAGE_SETTINGS = "Idioma:"
const DELETE_PROGRESS_SETTINGS = "Borrar progreso"
const EXIT_GAME_SETTINGS = "Salir del juego"
const LOADING_LANGUAGE_SETTINGS = "Loading language"
const MANAGE_ADS = "Anuncios"
const LOADING = "Cargando"

const RESET_BOARD = "¿REINICIAR TABLERO?"
const RESET_BOARD_MSG = "El estado actual del tablero se perderá"

const EXIT_GAME = "SALIR DEL JUEGO"
const EXIT_GAME_MSG = "¿Estás seguro?"

const RESET_PROGRESS = "¿BORRAR PROGRESO?"
const RESET_PROGRESS_MSG = "Todo el progreso será permanentemente borrado, incluyendo el tablero actual y los récords.\n\nNo perderás tus brócolis."

const OFFLINE = "SIN CONEXIÓN"
const OFFLINE_MSG = "Conéctate a Internet para conseguir brócolis y eliminar las fichas que te impiden avanzar"

const EXCUSE_BOOK = "EXCUSAS"
const EXCUSE_BOOK_LEGEND = "MÁXIMA ACTUAL"
const EXCUSE_BOOK_NEW = "NUEVO"
const EXCUSE_BOOK_NEW_SCALE = 0.8
const EXCUSE_BOOK_TUTORIAL1 = "FICHA COMPLETA"
const EXCUSE_BOOK_TUTORIAL2 = "REFUTACIÓN"

const GAME_OVER = "HAS PERDIDO"
const GAME_OVER_SCALE = 0.8
const GAME_OVER_MSG = "No quedan movimientos disponibles"
const GAME_OVER_OR = "O"
const GAME_OVER_QUESTION = "¿Ver anuncio a cambio de 3 brócolis?"
const GAME_OVER_QUESTION_AD_FREE = "Juega a Brócoli Fiesta para conseguir brócolis.\n\nOBJETIVO: Pulsa el botón PARAR para frenar al instante la ruleta. Ten cuidado, tendrás que ser rápido."
const GAME_OVER_PLAY_ROULETTE = "¡JUGAR!"

const WIN1 = "¡HAS"
const WIN2 = "GANADO!"
const WIN_MSG_ANDROID = "¡Has completado el juego! Ahora puedes seguir jugando para batir tus propios récords.\n\nPuedes apoyarnos puntuando en Google Play o compartiendo con tus amigos."
const WIN_MSG_IOS = "¡Has completado el juego! Ahora puedes seguir jugando para batir tus propios récords.\n\nPuedes apoyarnos puntuando en App Store o compartiendo con tus amigos."
const IOS_SCORE_US = "PUNTÚANOS"

const REWARDED_MSG = "¡PATOFERTA!\n\nConsigue 2 brócolis por ver un anuncio"
const DUCK_GAME_MSG = "Juega a Brocolitrón para conseguir brócolis\n\nOBJETIVO: Frena cada círculo y coloca los brócolis dentro de la región resaltada."

const BROCCOLI_INSTRUCTIONS = "Pulsa sobre una ficha para eliminarla"

const TAKE_A_LOOK = "VERSIÓN SIN ANUNCIOS"
const FIRST_ERROR9 = "El servidor no parece tener anuncios en este momento.\n\nTe hemos dado un brócoli gratis para que puedas seguir jugando.\n\nSi quieres, puedes comprar la versión Sin Anuncios para recibir contenido exclusivo y conseguir brócolis sin ver anuncios."
const ERROR9 = "El servidor no parece tener anuncios en este momento.\n\n\nTe hemos dado un brócoli gratis para que puedas seguir jugando."

const NOT_EEA = "Esta funcionalidad sólo está disponible dentro de la EEE (Espacio Económico Europeo)."

const RECORDS = "Récords"
const RECORDS_TIME = "Tiempo"
const RECORDS_USED_BROCCOLIS = "Brócolis usados"
const RECORDS_NO_RECORDS = "Aún no hay récords.\n\nEsta opción estará disponible después de haber completado el juego."

const STOP = "Parar"

const NEW_RECORD = "¡Nuevo Récord!"
const INSTRUCTIONS_BUTTON = "Cómo Jugar"

const GOAL = "OBJETIVO:"
const GOAL_DESCRIPTION = "Junta excusas con el mismo número hasta llegar a la novena.\n\nCada excusa representa algún argumento típico contra el veganismo."

const TIP1_1 = "Las excusas con el mismo número se juntarán"
const TIP1_2 = "¡Las excusas con diferente número no!"
const TIP1_3 = "Cada vez que las excusas son movidas, aparecerá una nueva en una posición aleatoria"
const TIP1_4 = "Todas las excusas del tablero se moverán hacia la dirección que indiques al deslizar."

const TIP2_1 = "Mientras más te acerques a la novena excusa, menos espacio tendrás, y por lo tanto el juego se hará más difícil."
const TIP2_2 = "Usa BRÓCOLIS para eliminar las fichas que te obstaculizan"
const TIP2_3 = "\nLa partida se pierde cuando el tablero está lleno, no quedan brócolis y no hay al menos 2 excusas que se puedan juntar.\n\n¿Conseguirás desbloquear las 9 excusas?"

const EXCUSES_NAME = "nombre de la excusa"
const EXCUSES_NUMBER = "número de la excusa"

const UPDATES_TITLE = "JUEGO ACTUALIZADO"
const UPDATES_TEXT = "NOVEDADES:\n\n- Botón de instrucciones en el menú de configuración.\n\n- Arreglos menores varios."

const TAP_ON_ME = "TOCA AQUÍ"

extends Node

var current_scene_state = null
var paused: bool = false
var pause_menu = null

var cat_counter = 0  # Licznik zwykłych kotków
var gruby_cat_counter = 0  # Licznik grubych kotków
var key_counter = false
signal wygranaMinigra
var life = 5
var globalLife = 5
var death_position = Vector2(-104,80)
var current_position = Vector2(-104,80)

var bushes_state = {}  # Przechowuje stany krzaków
var cats_state = {}  # Przechowuje stany kotków
var boxes_state = {} # Przechowuje stany kartonow
var gruby_cats_state = {}  # Przechowuje stany grubych kotków
var chests_state = {}  # Przechowuje stany skrzynek

var Cat_chests_state = {}  # Przechowuje stany skrzynek
var game_chests_state = {}  # Przechowuje stany skrzynek

var is_mini_game_won = false

func set_paused(is_paused):
	paused = is_paused

func reset_kitty_counter():
	cat_counter = 0
	gruby_cat_counter = 0
	
func reset_key_counter():
	key_counter = 0
		
func reset_life():
	globalLife = 5
	life = 5


func reset_position():
	death_position = Vector2(-104,80)
	
func reset_cats_state():
	for cat in cats_state:
		cats_state[cat] = {"is_collected": false, "visible": true}

func reset_gruby_cats_state():
	for gruby_cat in gruby_cats_state:
		gruby_cats_state[gruby_cat] = {"is_collected": false, "visible": true}

func reset_bushes_state():
	for bush in bushes_state:
		bushes_state[bush] = {"is_destroyed": false,"visible": true}
		
func reset_chests_state():
	for chest in chests_state:
		chests_state[chest] = {"is_opened": false}

func reset_boxes_state():
	var boxes = get_tree().get_nodes_in_group("Box")
	for box in boxes:
		if box.has_method("reset_box"):
			box.reset_box()
			print("Zresetowano karton: ", box.name)

	for c in Cat_chests_state:
		Cat_chests_state[c] = {"is_opened": false}
	for gamechest in game_chests_state:
		game_chests_state[gamechest] = {"is_opened": false}


func reset_game():
	reset_key_counter()
	reset_kitty_counter()
	reset_life()
	reset_position()
	reset_cats_state()
	reset_gruby_cats_state()
	reset_bushes_state()
	reset_chests_state()
	reset_boxes_state()

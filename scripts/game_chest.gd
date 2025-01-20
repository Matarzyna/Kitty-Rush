extends Node2D

@onready var game_chest_sprite: AnimatedSprite2D = $gameChestSprite
@onready var game_chest_area_2d: Area2D = $gameChestArea2D

var is_opening: bool = false
var is_opened: bool = false
var player_in_range: bool = false 

const KEY_SCENE_PATH := "res://złoty_klucz.tscn"
var Key_scene: PackedScene = preload(KEY_SCENE_PATH)

func _ready() -> void:
	game_chest_area_2d.body_entered.connect(_on_body_entered)
	game_chest_area_2d.body_exited.connect(_on_body_exited)
	
func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("open_chest"):
		if not is_opened and not is_opening:
			_open_chest()

func _on_body_entered(body: Node) -> void:
	if body.name == "Studentka":
		player_in_range = true  # Ustaw flagę

func _on_body_exited(body: Node) -> void:
	if body.name == "Studentka":
		player_in_range = false  # Resetuj flagę

func _open_chest() -> void:
	is_opening = true
	game_chest_sprite.play("opening")
	
	var animation_length = game_chest_sprite.sprite_frames.get_frame_count("opening") / game_chest_sprite.sprite_frames.get_animation_speed("opening")
	await get_tree().create_timer(animation_length).timeout
	
	game_chest_sprite.play("opened")
	
	is_opened = true
	is_opening = false

	_start_minigame()

func _start_minigame() -> void:
	pause()
	var minigame_scene = load("res://mini_games/kitty_catch/kitty_catch_game.tscn")
	if not minigame_scene:
		print("Błąd: Nie udało się załadować minigry.")
		return
		
	var minigame_instance = minigame_scene.instantiate()
	get_tree().root.add_child(minigame_instance)
	
	spawn_key()
		
func spawn_key() -> void:
	var Key_instance = Key_scene.instantiate()
	Key_instance.position = global_position + Vector2(0, 0)
	print("Pozycja klucza:", Key_instance.position)
	get_parent().add_child(Key_instance)
	
func pause():
	Global.set_paused(true)
	for node in get_tree().get_nodes_in_group("main_game_elements"):
		node.process_mode = Node.PROCESS_MODE_DISABLED

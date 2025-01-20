extends Node2D

@onready var game_chest_sprite: AnimatedSprite2D = $gameChestSprite
@onready var game_chest_area_2d: Area2D = $gameChestArea2D

var is_opening: bool = false
var is_opened: bool = false

const KEY_SCENE_PATH := "res://złoty_klucz.tscn"
var Key_scene: PackedScene = preload(KEY_SCENE_PATH)

func _ready() -> void:
	game_chest_area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Studentka" and not is_opened and not is_opening:
		_open_chest()

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
	
	if minigame_instance._get_is_game_won:
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

extends CharacterBody2D

@export var tile_size = 16  # Rozmiar kafelka (w pikselach)
@export var move_time = 0.3  # Czas ruchu w sekundach
@onready var ray = $RayCast2D
var start_position = Vector2.ZERO
@onready var ray_down = $RayCastDown
var is_moving = false 
var move_direction = Vector2.ZERO  # Kierunek ruchu
var is_fall = false;
var ruchome = false;
var dalej = true
var poczekac = false

var starting_position = position
var saving_position = Vector2()

func _ready() -> void:
	if Global.boxes_state.has(name):
		var state = Global.boxes_state[name]
		set_state(state)
	else:
		print("Brak zapisanego stanu dla kartonu:", name)
		starting_position = position

func _physics_process(delta):
	# Add the gravity.
	ray_down.set_target_position(Vector2.DOWN * 8.1)
	ray_down.force_raycast_update()
	if !ray_down.is_colliding() :
		if not is_fall:
			await get_tree().create_timer(0.4).timeout
			ray_down.force_raycast_update()
			if !ray_down.is_colliding():
				if poczekac:
					await get_tree().create_timer(0.4).timeout
				is_fall = true
				ruchome = true
				move(Vector2.DOWN)
		else:
			ruchome = true
			move(Vector2.DOWN)
	elif is_moving == false:
		if ruchome:
			ray_down.set_target_position(Vector2.DOWN * 8.1)
			ray_down.force_raycast_update()
			$RayCastRight.force_raycast_update()
			$RayCastLeft.force_raycast_update()
			if ray_down.get_collider():
				if ray_down.get_collider().is_in_group('player'):
					poczekac = true
				elif ray_down.get_collider().is_in_group('Box') :
					ray.set_target_position(Vector2.RIGHT * 23)
					ray.force_raycast_update()
					if (!ray.is_colliding() and !$RayCastRight.is_colliding()):
						move(Vector2.RIGHT)
						is_fall = true
						ruchome = true
						move(Vector2.DOWN)
					else:
						is_fall = false
						ruchome = false
					ray.set_target_position(Vector2.LEFT * 23)
					ray.force_raycast_update()
					if (!ray.is_colliding() and !$RayCastLeft.is_colliding()):
						move(Vector2.LEFT)
						is_fall = true
						ruchome = true
						move(Vector2.DOWN)
					else:
						is_fall = false
						ruchome = false
	else:
		is_fall = false
	saving_position = position

func start_movement(direction: Vector2):
	ray.set_target_position(direction * 16)
	ray.force_raycast_update() 
	if !ray.is_colliding():
		move(direction)
		return true
	else:
		return false

func move(direction: Vector2):
	if is_moving == false:
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self,"position", position + direction* 16, 0.3)
		tween.tween_callback(move_false)

func move_false():
	is_moving = false

func reset_box():
	position = starting_position

func set_state(state: Dictionary):
	position = state.get("position", starting_position)
	print("Pozycja pudełka wczytana:", position)

func _on_killzone_area_entered(area: Area2D) -> void:
	print("Obszar wykryty:", area.name)

	if area.is_in_group("wrogowie"):
		print("Wróg w killzone! Usuwanie całego body...")

		# Pobranie nadrzędnego noda i jego usunięcie
		var parent = area.get_parent()
		if parent:
			parent.queue_free()

extends CanvasLayer
	
var key_count
var sprite: Sprite2D

func _ready() -> void:
	sprite = $Sprite2D
	sprite.visible = false

func _process(delta: float) -> void:
	key_count = Global.key_counter
	update_sprite_status()
	

func update_sprite_status():
	#Gdy nie ma kluczy to nie pokazuj że jest klucz
	
	if key_count:
		sprite.visible = true
	else:
		sprite.visible = false
		

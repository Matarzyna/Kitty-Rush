extends CanvasLayer
	
var key_count = Global.key_counter

func update_sprite_status():
	#Gdy nie ma kluczy to nie pokazuj że jest klucz
	var sprite = $Sprite2D
	if key_count > 0:
		sprite.visible = true
	else:
		sprite.visible = false
		

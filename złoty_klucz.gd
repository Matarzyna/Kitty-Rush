extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	print("weszłam w klucz")
	Global.key_counter = true
	print(name, "klucz zebrany", Global.key_counter)
	queue_free()

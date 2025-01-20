extends Area2D

var is_collected = false

func _on_body_entered(_body: Node2D) -> void:
	if is_collected:
		return
	is_collected = true
	
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("set_visible", false)
	print(name, "klucz zebrany", Global.life)
	
	
	
func set_state(state):
	is_collected = state.get("is_collected", false)
	visible = state.get("visible", true)
	$CollisionShape2D.disabled = is_collected
	set_visible(visible)
	print("Stan klucza ustawiony:", name, "is_collected:", is_collected, "visible:", visible)

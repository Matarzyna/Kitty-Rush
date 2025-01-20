extends Area2D

var damage = 1

func _on_body_entered(body: Node2D) -> void:
	Global.life -= damage;
	body.notify_game_manager_check_life()
	print("You get hit")
	if(Global.life <= 0):
		print("You died")
		body.notify_game_manager_force_death()

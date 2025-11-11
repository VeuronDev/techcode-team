extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalVar.skull_taken = true
		GlobalVar.skull += 1
		await get_tree().create_timer(0.1).timeout
		GlobalVar.skull_taken = false
		queue_free()

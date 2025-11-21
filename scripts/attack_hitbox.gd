extends Area2D

#PROPERTY NODE
@onready var enemy = get_parent()

#MENYERANG PLAYER
func _on_body_entered(body) -> void:
	await get_tree().create_timer(0.6).timeout 
	var damage_to_player = randi_range(3, 7)
	GlobalVar.hurt_active = true
	GlobalVar.healthPlayer -= damage_to_player
	

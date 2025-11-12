extends Area2D

@onready var enemy = get_parent()

func _on_body_entered(body):
	await get_tree().create_timer(0.6).timeout 
	var damage_to_player = randi_range(3, 7)
	GlobalVar.hurt_active = true
	print("Player terkena damage: ", damage_to_player)
	GlobalVar.healthPlayer -= damage_to_player
	

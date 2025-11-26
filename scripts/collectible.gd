extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(_body):
	player.collectible_count = player.collectible_count + 1
	GlobalVar.point_player += 1
	print(player.collectible_count)
	queue_free()

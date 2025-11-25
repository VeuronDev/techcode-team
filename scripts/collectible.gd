extends Area2D

@onready var player = $"../../Player"

func _on_body_entered(body):
	player.collectible_count = player.collectible_count + 1
	print(player.collectible_count)
	queue_free()

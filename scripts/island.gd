extends Node2D
var game_over_processed = false

func _process(_delta: float) -> void:
	if (GlobalVar.healthPlayer <= 0 or GlobalVar.is_lose) and not game_over_processed:	
		game_over_processed = true
		if GlobalVar.is_lose:
			GlobalVar.is_lose = false
		GlobalVar.healthPlayer = 0
		$Player/music.stop()
		var lose = GlobalVar.LoseUI.instantiate()
		get_node("/root/island_%d"%GlobalVar.current_waves).add_child(lose)
		await get_tree().create_timer(10).timeout 
		GlobalVar.reset_all()
		queue_free()
		get_tree().change_scene_to_file("res://scenes/property/main_game.tscn")

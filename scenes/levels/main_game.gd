extends Node2D

func _on_play_pressed() -> void:
	$music_bg.stop()
	get_tree().change_scene_to_file("res://scenes/levels/dungeon.tscn")
	

func _on_exit_pressed() -> void:
	$music_bg.stop()
	get_tree().quit()

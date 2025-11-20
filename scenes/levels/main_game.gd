extends Node2D

@onready var music = $music_bg

func _on_play_pressed() -> void:
	music.stop()
	get_tree().change_scene_to_file("res://scenes/levels/dungeon.tscn")

func _on_exit_pressed() -> void:
	music.stop()
	get_tree().quit()

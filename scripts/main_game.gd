extends Node2D

#PROPERTY NODE
@onready var music = $music_bg

#BUTTON PLAY DI TEKAN
func _on_play_pressed() -> void:
	music.stop()
	get_tree().change_scene_to_file("res://scenes/property/dungeon.tscn")

#BUTTON EXIT DI TEKAN
func _on_exit_pressed() -> void:
	music.stop()
	get_tree().quit()

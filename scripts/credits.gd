extends Control

#KEMBALI KE MENU
func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/main_game.tscn")

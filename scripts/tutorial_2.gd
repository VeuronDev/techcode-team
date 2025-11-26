extends Control




func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/tutorial3.tscn")


func _on_back_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/tutorial1.tscn")

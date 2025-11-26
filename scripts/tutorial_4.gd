extends Control



func _on_play_pressed() -> void:
	GlobalVar.reset_all()
	GlobalVar.is_loading = true
	if GlobalVar.start_new_timir:
		GlobalVar.start_wave_with_timer()
		GlobalVar.start_new_timir = false	
	get_tree().change_scene_to_file("res://scenes/property/laoding.tscn")
	

func _on_back_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/tutorial3.tscn")

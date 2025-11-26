extends Control

#PROPERTY NODE
@onready var music = $music_bg

#BUTTON PLAY DI TEKAN
func _on_play_pressed() -> void:
	GlobalVar.reset_all()
	GlobalVar.is_loading = true
	if GlobalVar.start_new_timir:
		GlobalVar.start_wave_with_timer()
		GlobalVar.start_new_timir = false	
	get_tree().change_scene_to_file("res://scenes/property/laoding.tscn")

#BUTTON CREDIT DI TEKAN
func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/credits.tscn")

#BUTTON SETTINGS DI TEKAN
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/settings.tscn")

#BUTTON EXIT DI TEKAN
func _on_exit_pressed() -> void:
	music.stop()
	get_tree().quit()

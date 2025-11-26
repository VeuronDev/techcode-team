extends Control

#PROPERTY NODE
@onready var music = $music_bg

#BUTTON PLAY DI TEKAN
func _on_play_pressed() -> void:
	GlobalVar.is_loading = true
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

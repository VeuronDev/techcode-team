extends Control


func _process(_delta: float) -> void:
	if GlobalVar.tutor_step == false:
		$tutor/label.text = "On"
	else:
		$tutor/label.text = "Off"

#KEMABLI KE MENU
func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/main_game.tscn")
	
func _on_tutor_pressed() -> void:
	if GlobalVar.tutor_step == false:
		GlobalVar.tutor_step = true
	else:
		GlobalVar.tutor_step = false

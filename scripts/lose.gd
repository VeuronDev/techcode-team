extends CanvasLayer

func _ready() -> void:
	if GlobalVar.is_dead: return
	$"fade in".play("add")

func _on_exit_pressed() -> void:
	GlobalVar.reset_all()
	get_tree().change_scene_to_file("res://scenes/property/main_game.tscn")

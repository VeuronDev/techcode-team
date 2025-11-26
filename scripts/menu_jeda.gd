extends CanvasLayer

func _ready() -> void:
	$play.play("down")

func _process(_delta: float) -> void:
	if GlobalVar.menu_on:
		$play.play("down")
	else:
		$play.play("up")

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/main_game.tscn")

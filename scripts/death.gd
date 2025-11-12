extends State

func enter():
	super.enter()
	animation_player.play("death")
	
func boss_defeated():
	animation_player.play("boss_defeated")
	GlobalVar.Is_boss_alive = false

func victory():
	get_tree().change_scene_to_file("res://scenes/levels/main_game.tscn")

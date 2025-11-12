extends State

func enter():
	super.enter()
	animation_player.play("death")
	
func boss_defeated():
	animation_player.play("boss_defeated")
	GlobalVar.Is_boss_alive = false

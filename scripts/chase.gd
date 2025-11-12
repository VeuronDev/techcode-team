extends State

var can_transition: bool = false

func enter():
	super.enter()
	animation_player.play("run")
	can_transition = true 
	
func chase():
	owner.set_physics_process(true)
	owner.speed = 230
	
func  transition():
	if can_transition and owner.direction.length() < 200:
		get_parent().change_state("Follow")
		can_transition = false
		owner.speed = 80

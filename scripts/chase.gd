extends State

#PROPERTY CHASE
var can_transition: bool = false

#MENJALANKAN TRANSISI
func enter() -> void:
	super.enter()
	animation_player.play("run")
	can_transition = true 
	
#MENJALANKAN CHASE
func chase() -> void:
	owner.set_physics_process(true)
	owner.speed = 230
	
#JARAK TRANSISI
func  transition() -> void:
	if can_transition and owner.direction.length() < 150:
		get_parent().change_state("Follow")
		can_transition = false
		owner.speed = 80

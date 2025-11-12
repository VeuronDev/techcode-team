extends State

func _enter_tree():
	randomize()

func enter():
	super.enter()
	if owner.direction.length() > 700:
		get_parent().change_state("Idle")
	else :
		owner.set_physics_process(true)
		animation_player.play("walk")
		owner.attack_hitbox.monitoring = false
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
	
func transition():
	if owner.direction.length() < 80:
		get_parent().change_state("Attack")
	if owner.direction.length() > 300:
		var chance = randi() % 100
		if chance > 80:
			get_parent().change_state("SpawnMinion")
			owner.attack_hitbox.monitoring = false
		else :
			get_parent().change_state("Chase")
			owner.attack_hitbox.monitoring = false

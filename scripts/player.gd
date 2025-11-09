extends CharacterBody2D

@onready var player_sheet = $player_sheet
@onready var camera = $Camera2D

const BASESPEED = 450
var direction = 0

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
<<<<<<< Updated upstream
	
	velocity = direction * BASESPEED
	if Input.is_action_just_pressed("dodge"):
		velocity = direction * BASESPEED * 5
=======
	if Input.is_action_just_pressed("dodge") and can_roll:
		start_roll()
	if Input.is_action_just_pressed("talk_npc"):
		pass


#hancle roll process
func roll_hanlde(delta):
	if is_rolling:
		velocity = direction * ROLLSPEED
		roll_timer -= delta
		if roll_timer <= 0:
			stop_rolling()
	else :
		velocity = direction * BASESPEED
>>>>>>> Stashed changes
	move_and_slide()
	if velocity.length() > 0.0:
		player_sheet.play("run")
		if velocity.x < 0:
			player_sheet.flip_h = true
		else :
			player_sheet.flip_h = false
	else :
<<<<<<< Updated upstream
		player_sheet.play("idle")
=======
		player_sheet.flip_h = false
		
# screen shake
func screen_shake():
	pass
>>>>>>> Stashed changes
	

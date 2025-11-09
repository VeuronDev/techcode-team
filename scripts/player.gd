extends CharacterBody2D

const BASESPEED = 450
const ROLLSPEED = 750
const BASEROLLDURATION = 0.5
const BASEDROLLCOOLDOWN = 1.0

@onready var player_sheet = $player_sheet

var direction = 0
var is_rolling =false
var roll_timer = 0.0
var can_roll = true

func _physics_process(delta):
	input_handle()
	roll_hanlde(delta)
	if velocity.length() > 0.0 and is_rolling:
		player_sheet.play("roll")
	elif velocity.length() <= 0.0:
		player_sheet.play("idle")
	else :
		player_sheet.play("run")
	sprite_flip()

#handle input direction	
func input_handle():
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if Input.is_action_just_pressed("dodge") and can_roll:
		start_roll()


#hancle roll process
func roll_hanlde(delta):
	if is_rolling:
		velocity = direction * ROLLSPEED
		roll_timer -= delta
		if roll_timer <= 0:
			stop_rolling()
	else :
		velocity = direction * BASESPEED
	move_and_slide()
	
	
#to start roling 
func start_roll():
	is_rolling = true
	can_roll = false
	roll_timer = BASEROLLDURATION
	
	await get_tree().create_timer(BASEDROLLCOOLDOWN).timeout
	can_roll = true
	
#stop rolling
func stop_rolling():
	is_rolling = false
	
#flip the sprite	
func sprite_flip():
	if velocity.x < 0:
		player_sheet.flip_h = true
	else :
		player_sheet.flip_h = false
	

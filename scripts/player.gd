extends CharacterBody2D

@onready var player_sheet = $player_sheet

const BASESPEED = 450
var direction = 0

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	velocity = direction * BASESPEED
	if Input.is_action_just_pressed("dodge"):
		velocity = direction * BASESPEED * 5
	move_and_slide()
	if velocity.length() > 0.0:
		player_sheet.play("run")
		if velocity.x < 0:
			player_sheet.flip_h = true
		else :
			player_sheet.flip_h = false
	else :
		player_sheet.play("idle")
	

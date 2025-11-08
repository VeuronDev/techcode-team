extends CharacterBody2D

const BASESPEED = 450


@onready var player_sheet = $player_sheet

var direction = 0

func _physics_process(delta):
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * BASESPEED
	move_and_slide()
	if velocity.length() > 0.0:
		player_sheet.play("run")
		if velocity.x < 0:
			player_sheet.flip_h = true
		else :
			player_sheet.flip_h = false
	else :
		player_sheet.play("idle")
	

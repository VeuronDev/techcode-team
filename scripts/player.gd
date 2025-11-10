extends CharacterBody2D

const BASESPEED = 450
const ROLLSPEED = 750
const BASEROLLDURATION = 0.5
const BASEDROLLCOOLDOWN = 1.0

@onready var player_sheet = $player_sheet
@onready var cam = $Camera2D

var direction = Vector2.ZERO
var is_rolling = false
var roll_timer = 0.0
var can_roll = true

func _physics_process(delta):
	input_handle()
	roll_hanlde(delta)
	update_animation()

func input_handle():
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if Input.is_action_just_pressed("dodge") and can_roll and not GlobalVar.attack_active:
		start_roll()
	if Input.is_action_just_pressed("attack") and not GlobalVar.attack_active:
		GlobalVar.attack_active = true
		player_sheet.play("attack_sword")
		await get_tree().create_timer(0.2).timeout
		cam.add_trauma(0.3)
		await get_tree().create_timer(0.4).timeout
		GlobalVar.attack_active = false

func roll_hanlde(delta):
	if is_rolling:
		velocity = direction * ROLLSPEED
		roll_timer -= delta
		if roll_timer <= 0:
			stop_rolling()
	else:
		velocity = direction * BASESPEED

	move_and_slide()

func start_roll():
	is_rolling = true
	can_roll = false
	roll_timer = BASEROLLDURATION

	await get_tree().create_timer(BASEDROLLCOOLDOWN).timeout
	can_roll = true

func stop_rolling():
	is_rolling = false

func sprite_flip():
	if velocity.x < 0:
		player_sheet.flip_h = true
	elif velocity.x > 0:
		player_sheet.flip_h = false

func update_animation():
	if GlobalVar.attack_active:
		return
	if is_rolling:
		player_sheet.play("roll")
	elif velocity.length() > 0.0:
		player_sheet.play("run")
	else:
		player_sheet.play("idle")
	sprite_flip()

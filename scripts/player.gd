extends CharacterBody2D

const BASESPEED = 450
const ROLLSPEED = 750
const BASEROLLDURATION = 0.5
const BASEDROLLCOOLDOWN = 1.0

@onready var player_sheet = $player_sheet
@onready var cam = $Camera2D
@onready var coin_player = $Coin
@onready var health_bar = $HealthPlayer
@onready var notifications = $notification
@onready var take_notif = $notification/take

var direction = Vector2.ZERO
var is_rolling = false
var roll_timer = 0.0
var can_roll = true

func _physics_process(delta):
	health_bar.value = GlobalVar.healthPlayer
	if GlobalVar.apple_taken or GlobalVar.health_taken:
		notif_item()
	if GlobalVar.hurt_active:
		handle_hurt_status()
	input_handle()
	roll_hanlde(delta)
	update_animation()
	update_item_status()

func input_handle():
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if Input.is_action_just_pressed("dodge") and can_roll and not GlobalVar.attack_active:
		start_roll()
	if Input.is_action_just_pressed("attack") and not GlobalVar.attack_active:
		GlobalVar.attack_active = true
		player_sheet.play("attack_sword")
		await get_tree().create_timer(0.3).timeout
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

func handle_hurt_status():
	if GlobalVar.hurt_active:
		await get_tree().create_timer(0.4).timeout
		GlobalVar.hurt_active = false

func update_item_status():
	coin_player.text = "Apple : %d" % GlobalVar.apple

func update_animation():
	sprite_flip()
	if GlobalVar.attack_active:
		return
	if GlobalVar.hurt_active:
		player_sheet.play("hit")
		return
	if is_rolling:
		player_sheet.play("roll")
		return
	elif velocity.length() > 0.0:
		player_sheet.play("run")
	else:
		player_sheet.play("idle")
		
func notif_item() -> void:
	if GlobalVar.apple_taken:
		notifications.text = "+1 Apple"
		take_notif.play("notif_taken")
	elif GlobalVar.health_taken:
		notifications.text = "+30 Health"
		take_notif.play("notif_taken")

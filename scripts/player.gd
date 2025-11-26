extends CharacterBody2D

#PROPERTY NODE
@onready var player_sheet = $player_sheet
@onready var cam = $Camera2D
@onready var notifications = $notification
@onready var take_notif = $notification/take
@onready var kill_message = $KillMessage
@onready var hit = $Audio_Manager/hit
@onready var notif_kill = $Audio_Manager/notif_kill

#PROPERTY PLAYER
const BASESPEED: int = 450
const ROLLSPEED: int = 750
var roll_timer: float = 0.0
const BASEROLLDURATION: float = 0.5
const BASEDROLLCOOLDOWN: float = 1.0
var direction: Vector2 = Vector2.ZERO
var is_rolling: bool = false
var can_roll: bool = true
var collectible_count:int = 0

#READY SISTEM
func _ready() -> void:
	input_handle()
	#GlobalVar.spawn_wave_enemies(global_position)
	#GlobalVar.connect("show_kill_message", Callable(self, "_on_kill_message"))
	#GlobalVar.healthPlayer = 200

#KILL MESSAGE PLAYER
func _on_kill_message(text) -> void:
	notif_kill.play()
	kill_message.text = text
	kill_message.show()
	kill_message.modulate.a = 1
	kill_message.scale = Vector2(1.2, 1.2)
	kill_message.create_tween().tween_property(kill_message, "modulate:a", 0, 1.5)

#PENGECEKAN PLAYER SERANG/JALAN/SAKIT
func _physics_process(delta) -> void:
	if GlobalVar.apple_taken or GlobalVar.health_taken or GlobalVar.skull_taken:
		notif_item()
	if GlobalVar.hurt_active:
		handle_hurt_status()	
	input_handle()
	roll_hanlde(delta)
	update_animation()
	if GlobalVar.healthPlayer > 200:
		GlobalVar.healthPlayer = 200

#SISTEM PERGERAKAN PLAYER
func input_handle() -> void:
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	if Input.is_action_just_pressed("dodge") and can_roll and not GlobalVar.attack_active:
		start_roll()
	if Input.is_action_just_pressed("attack") and not GlobalVar.attack_active:
		GlobalVar.attack_active = true
		player_sheet.play("attack_sword")
		await get_tree().create_timer(0.3).timeout
		hit.play()
		cam.add_trauma(0.3)
		await get_tree().create_timer(0.4).timeout
		GlobalVar.attack_active = false
	if Input.is_action_just_pressed("use_item"):
		healing()

#PLAYER BERGULING
func roll_hanlde(delta) -> void:
	if is_rolling:
		velocity = direction * ROLLSPEED
		roll_timer -= delta
		if roll_timer <= 0:
			stop_rolling()
	else:
		velocity = direction * BASESPEED
	move_and_slide()

#MEMULAI BERGULING
func start_roll() -> void:
	is_rolling = true
	can_roll = false
	roll_timer = BASEROLLDURATION
	await get_tree().create_timer(BASEDROLLCOOLDOWN).timeout
	can_roll = true

#MENGHENTIKAN BERGULING
func stop_rolling() -> void:
	is_rolling = false

#MEMBALIKAN SPRITE
func sprite_flip() -> void:
	if velocity.x < 0:
		player_sheet.flip_h = true
	elif velocity.x > 0:
		player_sheet.flip_h = false

#MENGHANDLE STATUS SAKIT
func handle_hurt_status() -> void:
	if GlobalVar.hurt_active:
		await get_tree().create_timer(0.4).timeout
		GlobalVar.hurt_active = false
	if GlobalVar.healthPlayer <= 0:
		die()

#MENGUPDATE ANIMASI PLAYER
func update_animation() -> void:
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

#NOTIF ITEM YANG DI AMBIL
func notif_item() -> void:
	if GlobalVar.apple_taken:
		notifications.text = "+1 Apple"
		take_notif.play("notif_taken")
	elif GlobalVar.health_taken:
		notifications.text = "+30 Health"
		take_notif.play("notif_taken")
	elif GlobalVar.skull_taken:
		notifications.text = "+1 Skull"
		take_notif.play("notif_taken")

#HEAL PLAYER DARI ITEM APPLE/HEALTH
func healing() -> void:
	if GlobalVar.apple > 0 and GlobalVar.healthPlayer < 200:
		GlobalVar.healthPlayer += 15
		GlobalVar.apple -= 1
		notifications.text = "+15 HP!"
		take_notif.play("notif_taken")

#MATI
func die() -> void:
	GlobalVar.current_waves = 1
	GlobalVar.is_dead = true
	if GlobalVar.is_dead:
		var lose = GlobalVar.LoseUI.instantiate()
		get_node("/root/Tilemap").add_child(lose)

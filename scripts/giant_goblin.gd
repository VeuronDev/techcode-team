extends CharacterBody2D

#PROPERTY NODE
@onready var player = get_parent().find_child("Player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var attack_hitbox = $AttackHitbox
@onready var hit_area = $HitArea

#PROPERTY BOSS GOBLIN
var speed: int = 80
var direction : Vector2
var in_sword_area: bool = false
var is_hit : bool = false
var immune_time :float = 0.7
var spawn_invulnerability_time: float = 0.2 

#KETIKA HIT DI AREA
func _on_hit_area_body_entered(body) -> void:
	if is_instance_valid(player) and body == player:
		in_sword_area = true

#KETIKA HIT DI LUAR AREA
func _on_hit_area_body_exited(body) -> void:
	if is_instance_valid(player) and body == player:
		in_sword_area = false

#MENENTUKAN HEALTH BOSS GOBLIN
var health = 1000:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteSateMachine").change_state("Death")

#READY SISTEM
func _ready() -> void:
	is_hit = true
	attack_hitbox.monitoring = false
	hit_area.monitoring = true
	set_physics_process(true)
	await get_tree().create_timer(spawn_invulnerability_time).timeout
	is_hit = false

#LOOP MENGECEK PENGEJARAN BOSS GOBLIN KE PLAYER
func _process(_delta) -> void:
	if is_instance_valid(player):
		direction = player.position - position
		if in_sword_area and GlobalVar.attack_active and not is_hit:
			is_hit = true
			take_damage() 
			await get_tree().create_timer(immune_time).timeout
			is_hit = false
		if direction.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		direction = Vector2.ZERO

#KECEPATAN PLAYER BERDASARKAN JARAK
func _physics_process(delta) -> void:
	velocity = direction.normalized() * speed 
	move_and_collide(velocity * delta)

#MEMBERIKAN DAMAGE KE PLAYER
func take_damage() -> void:
	health -= randi_range(20, 40)

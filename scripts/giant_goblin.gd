extends CharacterBody2D

@onready var player = get_parent().find_child("Player")

@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var attack_hitbox = $AttackHitbox
@onready var hit_area = $HitArea

var speed = 80
var direction : Vector2
var in_sword_area: bool = false
var immune_time :float = 0.7
var is_hit : bool = false
# Jeda untuk mencegah serangan instan saat spawn
var spawn_invulnerability_time: float = 0.2 


func _on_hit_area_body_entered(body):
	if is_instance_valid(player) and body == player:
		in_sword_area = true
		
func _on_hit_area_body_exited(body):
	if is_instance_valid(player) and body == player:
		in_sword_area = false
		
var health = 1000:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteSateMachine").change_state("Death")
			
func _ready():
	# 1. Mulai dengan is_hit = true untuk mencegah damage instan (invulnerability)
	is_hit = true
	attack_hitbox.monitoring = false
	hit_area.monitoring = true
	
	# 2. Aktifkan pergerakan segera setelah siap
	set_physics_process(true)
	
	# 3. Tunggu sebentar lalu non-aktifkan invulnerability
	await get_tree().create_timer(spawn_invulnerability_time).timeout
	is_hit = false
	
func _process(_delta):
	if is_instance_valid(player):
		# Logic mengejar
		direction = player.position - position
		
		# Logic menerima damage (pemain menyerang musuh)
		if in_sword_area and GlobalVar.attack_active and not is_hit:
			is_hit = true
			take_damage() 
			await get_tree().create_timer(immune_time).timeout
			is_hit = false
			
		# Logic flip sprite
		if direction.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		direction = Vector2.ZERO

func _physics_process(delta):
	velocity = direction.normalized() * speed 
	move_and_collide(velocity * delta)
	
func take_damage():
	health -= randi_range(6, 10)

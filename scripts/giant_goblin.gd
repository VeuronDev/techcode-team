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

func _on_hit_area_body_entered(body):
	if body.name == "Player":
		in_sword_area = true
		
func _on_hit_area_body_exited(body):
	if body.name == "Player":
		in_sword_area = false


var health = 1000:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteSateMachine").change_state("Death")


func _ready():
	set_physics_process(false)
	attack_hitbox.monitoring = false
	hit_area.monitoring = true
	
func _process(_delta):
	direction = player.position - position
	if in_sword_area and GlobalVar.attack_active and not is_hit:
		is_hit = true
		await get_tree().create_timer(immune_time).timeout
		take_damage()
		is_hit = false
		
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * speed 
	move_and_collide(velocity * delta)
	
func take_damage():
	health -= randi_range(6, 10)
	

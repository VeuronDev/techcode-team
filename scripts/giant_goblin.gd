extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var attack_hitbox = $AttackHitbox

var speed = 80
var direction : Vector2

var health = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteSateMachine").change_state("Death")

func _ready():
	set_physics_process(false)
	attack_hitbox.monitoring = false
	
func _process(_delta):
	direction = player.position - position
	
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * speed 
	move_and_collide(velocity * delta)
	
func take_damage():
	health -= 3
	

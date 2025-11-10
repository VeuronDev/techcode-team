extends CharacterBody2D

const BASE_SPEED = 300
const MAX_HEALTH = 100

@onready var animated_sprite_2d = $Sheet
@onready var health_bar = $HealthBar

var player_post
var target: CharacterBody2D
var in_sword_area = false
var is_hit = false
var is_dead = false
var health = MAX_HEALTH

func _ready():
	player_post = get_node("/root/mainGame/Player")
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health

func _physics_process(delta):
	if is_dead:
		velocity = Vector2.ZERO
		return
	
	if is_hit:
		velocity = Vector2.ZERO
	else:
		if target:
			var direction = global_position.direction_to(player_post.global_position)
			velocity = direction * BASE_SPEED
		else:
			velocity = Vector2.ZERO

	# Animasi
	if is_dead:
		animated_sprite_2d.play("death")
	elif is_hit:
		animated_sprite_2d.play("hit")
	elif velocity.length() > 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()
	animated_sprite_2d.flip_h = velocity.x < 0

	# Cek serangan player
	if in_sword_area and GlobalVar.attack_active and not is_hit and not is_dead:
		take_damage(randi_range(10, 15))

func _on_area_enemy_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body

func _on_area_enemy_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		target = null

func _on_area_sword_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_sword_area = true

func _on_area_sword_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_sword_area = false

func take_damage(amount: int):
	is_hit = true
	velocity = Vector2.ZERO
	health -= amount
	health_bar.value = health

	if health <= 0:
		die()
	else:
		animated_sprite_2d.play("hit")
		await get_tree().create_timer(0.6).timeout
		is_hit = false

func die():
	is_dead = true
	is_hit = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("death")
	GlobalVar.coin += 1
	await get_tree().create_timer(1).timeout
	queue_free()

extends CharacterBody2D

const BASE_SPEED = 300
const MAX_HEALTH = 100
const apple = preload("res://scenes/item/apple.tscn")
const potion = preload("res://scenes/item/potion.tscn")
const ATTACK_COOLDOWN = 1.5

# 🔹 Parameter untuk gerak acak (patrol)
const WANDER_RADIUS = 120.0
const WANDER_WAIT = 1.5

@onready var animated_sprite_2d = $Sheet
@onready var health_bar = $HealthBar

var player_post
var target: CharacterBody2D
var in_sword_area = false
var is_hit = false
var is_dead = false
var is_attacking = false
var health = MAX_HEALTH
var attack_timer = 0.0

# 🔹 Variabel patrol
var origin_position: Vector2
var wander_target: Vector2
var wander_wait_timer: float = 0.0

func _ready():
	player_post = get_node("/root/mainGame/Player")
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health
	origin_position = global_position
	_set_new_wander_target()


func _physics_process(delta):
	randomize()
	
	if attack_timer > 0:
		attack_timer -= delta
	
	if is_dead:
		velocity = Vector2.ZERO
		return

	if in_sword_area and not is_hit and not is_dead and attack_timer <= 0:
		play_attack()
	elif is_hit or is_attacking:
		velocity = Vector2.ZERO
	else:
		if target:
			# 🔹 Kejar player
			var direction = global_position.direction_to(player_post.global_position)
			velocity = direction * BASE_SPEED
		else:
			# 🔹 Bergerak acak di sekitar area spawn
			_wander_behavior(delta)

	# 🔹 Animasi
	if is_dead:
		animated_sprite_2d.play("death")
	elif is_hit:
		animated_sprite_2d.play("hit")
	elif is_attacking:
		animated_sprite_2d.play("attack")
	elif velocity.length() > 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision:
			velocity = -velocity * 0.5
			animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
			_set_new_wander_target()
			break
	if target:
		animated_sprite_2d.flip_h = player_post.global_position.x < global_position.x
	elif velocity.length() > 0:
		animated_sprite_2d.flip_h = velocity.x < 0

	if in_sword_area and GlobalVar.attack_active and not is_hit and not is_dead:
		take_damage(randi_range(10, 15))


# === 🧠 GERAK ACAK DI SEKITAR ===
func _wander_behavior(delta):
	if wander_wait_timer > 0:
		wander_wait_timer -= delta
		velocity = Vector2.ZERO
		return
	
	var direction = global_position.direction_to(wander_target)
	velocity = direction * (BASE_SPEED * 0.4) # lebih lambat dari kejar player

	if global_position.distance_to(wander_target) < 10:
		wander_wait_timer = WANDER_WAIT
		_set_new_wander_target()

func _set_new_wander_target():
	var offset = Vector2(randf_range(-WANDER_RADIUS, WANDER_RADIUS), randf_range(-WANDER_RADIUS, WANDER_RADIUS))
	wander_target = origin_position + offset


# === ⚔️ COLLISION ===
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


# === ❤️ DAMAGE & ATTACK ===
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

func play_attack():
	if is_dead or is_hit or is_attacking:
		return
	attack_timer = ATTACK_COOLDOWN	
	is_attacking = true	
	velocity = Vector2.ZERO
	animated_sprite_2d.play("attack")

	await get_tree().create_timer(0.6).timeout 
	var damage_to_player = randi_range(1, 5)
	GlobalVar.hurt_active = true
	GlobalVar.healthPlayer -= damage_to_player
	print("Player terkena damage:", damage_to_player)
	is_attacking = false


# === 🍎 DROP ITEM ===
func init_apple_position(count: int):
	for i in count:
		var apple_instance = apple.instantiate()
		var offset_x = randf_range(-50.0, 50.0)
		var offset_y = randf_range(-50.0, 50.0)
		var random_offset = Vector2(offset_x, offset_y)
		apple_instance.position = position + random_offset
		get_parent().add_child(apple_instance)

func die():
	is_dead = true
	is_hit = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("death")
	await get_tree().create_timer(1).timeout
	queue_free()
	init_apple_position(int(randf_range(1, 3)))

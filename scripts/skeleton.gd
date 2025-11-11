extends CharacterBody2D

const BASE_SPEED = 300
const MAX_HEALTH = 100
const apple = preload("res://scenes/item/apple.tscn")
const potion = preload("res://scenes/item/potion.tscn")

@onready var animated_sprite_2d = $Sheet
@onready var health_bar = $HealthBar
const ATTACK_COOLDOWN = 1.5

var player_post
var target: CharacterBody2D
var in_sword_area = false
var is_hit = false
var is_dead = false
var is_attacking = false
var health = MAX_HEALTH
var attack_timer = 0.0

func _ready():
	player_post = get_node("/root/mainGame/Player")
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health

func _physics_process(delta):
	randomize()
	if attack_timer > 0:
		attack_timer -= delta
	if is_dead:
		velocity = Vector2.ZERO
		return
	if in_sword_area and not is_hit and not is_dead and attack_timer <= 0:
		play_attack()
	if is_hit or is_attacking:
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
	elif is_attacking:
		animated_sprite_2d.play("attack")
	elif velocity.length() > 0:
		animated_sprite_2d.play("walka")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()
	if target:
		animated_sprite_2d.flip_h = player_post.global_position.x < global_position.x
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
		
func play_attack():
	if is_dead or is_hit or is_attacking:
		return
	attack_timer = ATTACK_COOLDOWN	
	is_attacking = true	
	velocity = Vector2.ZERO
	animated_sprite_2d.play("attack")

	await get_tree().create_timer(0.6).timeout 
	var damage_to_player = randi_range(1, 5)
	GlobalVar.healthPlayer -= damage_to_player
	GlobalVar.hurt_active = true
	print("Player terkena damage: ", damage_to_player)
	is_attacking = false
	
func init_apple_position(count: int):
	for i in count:
		var apple_instance = apple.instantiate()
		var offset_x = randf_range(-50.0, 50.0) 
		var offset_y = randf_range(-50.0, 50.0)
		var random_offset = Vector2(offset_x, offset_y)		
		apple_instance.global_position = global_position + random_offset	
		get_parent().add_child(apple_instance)

func die():
	is_dead = true
	is_hit = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("death")
	await get_tree().create_timer(1).timeout
	queue_free()
	init_apple_position(int(randf_range(1, 3)))

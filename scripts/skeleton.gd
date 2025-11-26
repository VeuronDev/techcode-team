extends CharacterBody2D

#PROPERTY SCENES
const apple = preload("res://scenes/item/apple.tscn")
const potion = preload("res://scenes/item/potion.tscn")
const skull = preload("res://scenes/item/skull.tscn")

#PROPERTY NODE
@onready var animated_sprite_2d = $Sheet
@onready var health_bar = $HealthBar
@onready var hurt = $Audio_Manager/hurt

#PROPERTY SKELETON
var wander_wait_timer: float = 0.0
const ATTACK_COOLDOWN: float = 1.5
const WANDER_RADIUS: float = 120.0
const WANDER_WAIT: float = 1.5
var attack_timer: float = 0.0
const BASE_SPEED: int = 300
const MAX_HEALTH: int = 100
var health: int = MAX_HEALTH
var target: CharacterBody2D
var in_sword_area: bool = false
var is_hit: bool = false
var is_dead: bool = false
var is_attacking: bool = false
var origin_position: Vector2
var wander_target: Vector2
var player_post
var despawncounter:int = 0


#READY SISTEM
func _ready() ->void:
	player_post = get_tree().get_first_node_in_group("Player")
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health
	origin_position = global_position
	_set_new_wander_target()

#LOOP PENGECEKAN SERANG/JALAN
func _physics_process(delta) -> void:
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
			var direction = global_position.direction_to(player_post.global_position)
			velocity = direction * BASE_SPEED
		else:
			_wander_behavior(delta)
	if is_dead:
		animated_sprite_2d.play("death")
	elif is_hit:
		animated_sprite_2d.play("hit")
	elif is_attacking:
		animated_sprite_2d.play("attack")
	elif velocity.length() > 0:
		animated_sprite_2d.play("walk")
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
		take_damage(randi_range(10, 15)+(GlobalVar.attack_ability))

#JALAN SECARA ACAK
func _wander_behavior(delta) -> void:
	if wander_wait_timer > 0:
		wander_wait_timer -= delta
		velocity = Vector2.ZERO
		return
	var direction = global_position.direction_to(wander_target)
	velocity = direction * (BASE_SPEED * 0.4)
	if global_position.distance_to(wander_target) < 10:
		wander_wait_timer = WANDER_WAIT
		#if wander_wait_timer > 1.0:
			#despawncounter += 1
			#if despawncounter > 5:
				#queue_free()
		_set_new_wander_target()

#JARAK JALAN TERHADAP TITIK SPAWN
func _set_new_wander_target() -> void:
	var offset = Vector2(randf_range(-WANDER_RADIUS, WANDER_RADIUS), randf_range(-WANDER_RADIUS, WANDER_RADIUS))
	wander_target = origin_position + offset
	
#PENGECEKAN PLAYER MEMASUKIN AREA SERANG
func _on_area_enemy_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
		despawncounter = 0
		
func _on_area_enemy_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		target = null

#PENGECEKAN PEDANG PLAYER DI AREA GOBLIN
func _on_area_sword_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_sword_area = true
func _on_area_sword_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_sword_area = false

#MENERIMA DAMAGE DARI PLAYER
func take_damage(amount: int) -> void:
	is_hit = true
	hurt.play()
	velocity = Vector2.ZERO
	health -= amount
	health_bar.value = health
	if health <= 0:
		die()
	else:
		animated_sprite_2d.play("hit")
		await get_tree().create_timer(0.6).timeout
		is_hit = false

#MENYERANG PLAYER
func play_attack() -> void:
	if is_dead or is_hit or is_attacking:
		return
	attack_timer = ATTACK_COOLDOWN	
	is_attacking = true	
	velocity = Vector2.ZERO
	animated_sprite_2d.play("attack")
	await get_tree().create_timer(0.6).timeout 
	var damage_to_player = randi_range(10*GlobalVar.current_waves, 20*GlobalVar.current_waves) - (GlobalVar.defend_ability + 5)
	GlobalVar.hurt_active = true
	GlobalVar.healthPlayer -= damage_to_player
	is_attacking = false

#MENJATUHKAN ITEM
func init_dropped_items(count: int) -> void:
	for i in range(count):
		var rand_drop = randf()
		var drop_scene
		if rand_drop < 0.6:
			drop_scene = apple
		elif rand_drop < 0.9:
			drop_scene = potion
		else:
			drop_scene = skull
		var drop_instance = drop_scene.instantiate()	
		var offset_x = randf_range(-50.0, 50.0)
		var offset_y = randf_range(-50.0, 50.0)
		var random_offset = Vector2(offset_x, offset_y)		
		drop_instance.global_position = position + random_offset
		get_parent().add_child(drop_instance)

#MATI
func die() -> void:
	is_dead = true
	is_hit = false
	velocity = Vector2.ZERO
	GlobalVar.add_kill()
	GlobalVar.enemy_died()
	GlobalVar.logPlayer("💀 You killed the Tengkorak Enemy.")
	GlobalVar.expPlayer += randi_range(5, 10)
	animated_sprite_2d.play("death")
	await get_tree().create_timer(1).timeout
	queue_free()
	init_dropped_items(int(randf_range(1, 3)))

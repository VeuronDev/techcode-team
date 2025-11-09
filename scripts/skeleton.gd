extends CharacterBody2D

const BASE_SPEED = 100

@onready var animated_sprite_2d = $Sheet

var player_post
var target: CharacterBody2D
var in_sword_area = false  # status apakah lagi kena pedang

func _ready():
	player_post = get_node("/root/mainGame/Player")

func _physics_process(delta):
	if target:
		var direction = global_position.direction_to(player_post.global_position)
		velocity = direction * BASE_SPEED
	else:
		velocity = Vector2.ZERO

	# kalau musuh lagi kena pedang dan attack lagi aktif
	if in_sword_area and GlobalVar.attack_active:
		animated_sprite_2d.play("hit")
	elif velocity.length() > 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()

	animated_sprite_2d.flip_h = velocity.x < 0

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

extends CharacterBody2D

const BASE_SPEED = 100

@onready var animated_sprite_2d = $Sheet

var player_post
var target: CharacterBody2D

func _ready():
	player_post = get_node("/root/mainGame/Player")
	target = null
	
func _physics_process(delta):
	if target:
		var direction = global_position.direction_to(player_post.global_position)
		velocity = direction * BASE_SPEED
	else:
		velocity = Vector2.ZERO
	if velocity.length() > 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	move_and_slide()
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

func _on_area_enemy_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
	
func _on_area_enemy_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		target = null

extends CharacterBody2D

const BASE_SPEED = 100

@onready var animated_sprite_2d = $AnimatedSprite2D

var player_post

func _ready():
	player_post = get_node("/root/mainGame/Player")

func _physics_process(delta):
	var direction = global_position.direction_to(player_post.global_position)
	velocity = direction * BASE_SPEED
	move_and_slide()
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	else :
		animated_sprite_2d.flip_h = false
	

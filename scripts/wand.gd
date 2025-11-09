extends Node2D

const FIREBALL = preload("uid://bv7cvtecypf6m")

const BASEFIRERATE = 0.2
const BASEBULLETSPEED = 600

var can_cast = true

func _process(delta):
	if Input.is_action_just_pressed("attack") and can_cast:
		cast()
		look_at(get_global_mouse_position())

func cast():
	can_cast = false
	var bullet = FIREBALL.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = rotation
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	
	await get_tree().create_timer(BASEFIRERATE).timeout
	can_cast = true

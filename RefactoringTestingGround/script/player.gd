extends CharacterBody2D



@onready var animation = $AnimationPlayer


var speed = 300
var can_roll:bool = true
var rolling:bool = false
var attaking:bool = false



func _physics_process(delta):
	animationmanager()
	Userinput()
	
func Userinput():
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * speed
	move_and_slide()
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("dodge") and can_roll:
		roll()
		
func roll():
	can_roll = false
	rolling = true
	speed *= 1.5
	animation.play("roll")
	await animation.animation_finished
	can_roll = true
	speed /= 1.5
	rolling = false
	
func animationmanager():
	if not attaking and not rolling and velocity == Vector2(0,0):
		animation.play("idle")
	elif not attaking and not rolling:
		animation.play("run")
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_just_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
		
func attack():
	attaking = true
	animation.play("attack1")
	await animation.animation_finished
	attaking = false
	
	
func death():
	animation.play("death")
	await animation.animation_finished
	

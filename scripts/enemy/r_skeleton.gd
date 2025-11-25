extends CharacterBody2D

@onready var health_bar = $HealthBar
@onready var info = $info
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var aggrorange = $AggroRange/CollisionShape2D

const BASESTATS = {
	"BASEHP": 50, 
	"BASEDMG": 2, 
	"BASESPD": 200,
	}
var stats = {
	"HP": 200,
	"DMG": 12,
	"SPD": 50}
var current_stats = {
	"currentHP": BASESTATS.BASEHP + stats.HP,
	"currentDMG": BASESTATS.BASEDMG + stats.DMG,
	"currentSPD": BASESTATS.BASESPD + stats.SPD,
	}

var location:Vector2
var aggroed:bool = false

func _ready():
	health_bar.visible = false
	add_user_signal("justattack",)
func _physics_process(_delta):
	facing()
	if aggroed:
		aggro()
		moveto()
	else :
		wander()
		moveto()
	animationchange()
	
	
func moveto():
	var direction = location
	velocity = direction * current_stats.currentSPD
	move_and_slide()
	
func wander():
	var pattern = randi() % 10
	await $Timer.timeout
	if pattern > 2 and pattern <= 6 :
		location = Vector2(randf(),randf()) * Vector2(randf_range(1.0,-1.0),randf_range(1.0,-1.0))
	elif pattern > 6 and pattern <= 8 : 
		location = global_position.direction_to(player.global_position)
	else :
		location = Vector2(0,0)

func aggro():
	if aggroed:
		location = global_position.direction_to(player.global_position)
	else : pass
	
func facing():
	if velocity.x < 0:
		%SpriteAnimation.flip_h = true
	else :
		%SpriteAnimation.flip_h = false
func animationchange():
	if not velocity == Vector2(0,0) :
		%SpriteAnimation.play_walk()
	else: 
		%SpriteAnimation.play_idle() 
	
func attacking():
	%SpriteAnimation.play("attack")
	await %SpriteAnimation.animation_finished
	
	
func _on_aggro_range_body_entered(_body):
	aggroed = true
	aggrorange.shape.radius *= 2
	health_bar.visible = true

func _on_aggro_range_body_exited(_body):
	aggroed = false
	aggrorange.shape.radius /= 2

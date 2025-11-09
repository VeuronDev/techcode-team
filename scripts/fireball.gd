extends Area2D

const FLYSPEED = 600
const  LIFETIME = 2.0

var direction: Vector2 = Vector2.RIGHT

func _ready():
	await get_tree().create_timer(LIFETIME).timeout
	queue_free()
	
func _physics_process(delta):
	global_position += direction * FLYSPEED * delta
	
func _on_body_entered(body):
	queue_free()

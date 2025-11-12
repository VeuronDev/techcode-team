extends State

@onready var collision = $"../../PlayerDetection/CollisionShape2D"
@onready var progress_bar = owner.find_child("ProgressBar")

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disable", value)
		progress_bar.set_deferred("visible", value)

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player_entered = true
		
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		player_entered = false
		
func transition():
	if player_entered :
		get_parent().change_state("Follow")
	

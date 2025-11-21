extends State

#PROPERTY NODE
@onready var collision = $"../../PlayerDetection/CollisionShape2D"
@onready var progress_bar = owner.find_child("ProgressBar")

#KETIKA PLAYER ENTERED
var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disable", value)
		progress_bar.set_deferred("visible", value)

#MENDETEKSI PLAYER
func _on_player_detection_body_entered(body) -> void:
	if body.name == "Player":
		player_entered = true
func _on_player_detection_body_exited(body)  -> void:
	if body.name == "Player":
		player_entered = false
		
#MELAKUKAN TRANSISI
func transition()  -> void:
	if player_entered :
		get_parent().change_state("Follow")
	

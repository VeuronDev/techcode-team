extends Camera2D

var amount = Vector2(1,1)
var duration:float = 0.0

func _physics_process(delta):
	if duration > 0.0:
		shake()

	
func shake():
	offset = (amount * Vector2(randf_range(-1.0,1.0)*duration,randf_range(-1.0,1.0)*duration) )
	duration -= 0.1
	
func startshake():
	duration = clamp( duration+3.0,0.0,5.0 )

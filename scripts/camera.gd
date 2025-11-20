extends Camera2D

@export var max_offset: Vector2 = Vector2(100, 75)
@export var max_roll: float = 0.1
@export var trauma_power: int = 2
var trauma: float = 0.0

func _process(_delta):
	if trauma > 0:
		shake()

func shake():
	if trauma <= 0:
		return
	var amount = pow(trauma, trauma_power)	
	rotation = deg_to_rad(max_roll) * amount * randf_range(-1, 1)
	offset = Vector2(
		max_offset.x * amount * randf_range(-1, 1),
		max_offset.y * amount * randf_range(-1, 1)
	)
	trauma = max(trauma - 0.05, 0)

func add_trauma(amount: float):
	trauma = clamp(trauma + amount, 0, 1)

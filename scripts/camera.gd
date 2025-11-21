extends Camera2D

#PROPERTY VARIABLE
@export var max_offset: Vector2 = Vector2(100, 75)
@export var max_roll: float = 0.1
var trauma: float = 0.0
@export var trauma_power: int = 2

#LOOP PENGECEKAN SHAKE CAMERA
func _process(_delta) -> void:
	if trauma > 0:
		shake()

#SHAKE CAMERA
func shake() -> void:
	if trauma <= 0:
		return
	var amount = pow(trauma, trauma_power)	
	rotation = deg_to_rad(max_roll) * amount * randf_range(-1, 1)
	offset = Vector2(
		max_offset.x * amount * randf_range(-1, 1),
		max_offset.y * amount * randf_range(-1, 1)
	)
	trauma = max(trauma - 0.05, 0)

#KEKUATAN SHAKE CAMERA
func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0, 1)

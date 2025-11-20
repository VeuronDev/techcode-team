extends Node2D

@onready var skeleton_scene = preload("res://scenes/characters/skeleton.tscn")
@onready var goblin_scene = preload("res://scenes/characters/goblin.tscn")

func _ready():
	spawn_random_enemies(GlobalVar.current_waves * 2)
	add_to_group("spawn_manager_group")

func spawn_random_enemies(count: int) -> void:
	var spawn_points: Array = []
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)
	if spawn_points.is_empty():
		print("ERROR: No Marker2D spawn points found!")
		return
	count = min(count, spawn_points.size())
	spawn_points.shuffle()
	var selected_points = spawn_points.slice(0, count)
	for point in selected_points:
		var enemy_scene = skeleton_scene if randf() < 0.5 else goblin_scene
		var enemy = enemy_scene.instantiate()
		enemy.global_position = point.global_position
		add_child(enemy)
	GlobalVar.start_wave(count)

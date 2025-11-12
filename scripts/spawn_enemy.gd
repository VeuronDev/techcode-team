extends Node2D

@onready var skeleton_scene = preload("res://scenes/characters/skeleton.tscn")
@onready var goblin_scene = preload("res://scenes/characters/Goblin.tscn")

func _ready() -> void:
	randomize() # <--- Tambahkan ini untuk hasil acak yang berbeda setiap kali
	spawn_random_enemies(5) # Coba lebih banyak musuh (misalnya 5)

func spawn_random_enemies(count: int) -> void:
	var spawn_points: Array = []
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)
	
	if spawn_points.is_empty():
		print("ERROR: No Marker2D spawn points found!") # Tambahkan debug log
		return
	
	count = min(count, spawn_points.size())
	spawn_points.shuffle()
	var selected_points = spawn_points.slice(0, count)
	
	for point in selected_points:
		# Pilih scene musuh secara acak
		var enemy_scene = skeleton_scene if randf() < 0.5 else goblin_scene
		var enemy = enemy_scene.instantiate()		
		
		# Set posisi global musuh ke posisi Marker2D
		enemy.global_position = point.global_position
		
		# Tambahkan musuh sebagai anak dari Node yang menjalankan skrip ini
		add_child(enemy)
		
		print("Spawned enemy at: ", point.global_position) # Tambahkan debug log

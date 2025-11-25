extends Node

@onready var player = $"../Player"

var enemie_skeleton = preload("res://scenes/characters/skeleton.tscn")
var enemie_goblin = preload("res://scenes/characters/goblin.tscn")
var new_enemy
var mob_cap:int = 0
	
func _process(_delta):
	dificulty()

func spawnenemies():
	var enemytype = randi() % 2
	if enemytype == 1 :
		new_enemy = enemie_skeleton.instantiate()
	else :
		new_enemy = enemie_goblin.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.position = %PathFollow2D.global_position
	add_child(new_enemy)
	print(get_child_count())

func dificulty():
	match player.collectible_count:
		5: mob_cap = 2
		10: mob_cap = 3
		15: mob_cap = 4
		20: mob_cap = 5
		25: mob_cap = 6
		30: mob_cap = 7
		35: mob_cap = 8
		40: mob_cap = 9
		45: mob_cap = 10
		50: mob_cap = 11
		55: mob_cap = 12
		60: mob_cap = 13
		65: mob_cap = 14
		70: mob_cap = 15
		75: mob_cap = 16
		80: mob_cap = 17
		
func _on_spawn_rate_timeout():
	if get_child_count() < (mob_cap + 1) :
		spawnenemies()
		print(str(mob_cap)+ " Cap")
		print(str(get_child_count()) + "Node")
		emit_signal("script_changed")
	

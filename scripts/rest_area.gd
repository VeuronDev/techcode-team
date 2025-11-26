extends Control

#COUNT ABILITY
@onready var attack_count = $attack_ability/attack_point
@onready var defend_count = $defend_ability/defend_point
@onready var health_count = $health_ability/health_point
@onready var current_wave = $current_wave
@onready var point_count = $point_player
@onready var level = $level_player

func _process(_delta: float) -> void:
	point_count.text = "Point : %d" % GlobalVar.point_player
	var lvl = GlobalVar.expPlayer % 100
	level.text = "My level : %d" % lvl
	current_wave.text = "Current wave : %d"%GlobalVar.current_waves
	attack_count.text = "Point : %d"%GlobalVar.attack_ability
	defend_count.text  = "Point : %d"%GlobalVar.defend_ability
	health_count.text = "Point : %d"%GlobalVar.health_ability
	
#ADD ABILITY
func _on_attack_ability_pressed() -> void:
	add_ability("attack")
func _on_add_attack_pressed() -> void:
	add_ability("attack")


func _on_defend_ability_pressed() -> void:
	add_ability("defend")
func _on_add_defend_pressed() -> void:
	add_ability("defend")

func _on_health_ability_pressed() -> void:
	add_ability("health")
func _on_add_health_pressed() -> void:
	add_ability("health")


#NEXT WAVE
func _on_next_wave_pressed() -> void:
	GlobalVar.is_loading = true
	get_tree().change_scene_to_file("res://scenes/property/laoding.tscn")
	GlobalVar.start_next_wave()

func add_ability(_point) -> void:
	if GlobalVar.point_player <= 3: 
		return
	if _point == "attack":
		GlobalVar.attack_ability += 1
	elif _point == "defend":
		GlobalVar.defend_ability += 1
	elif _point == "health":
		GlobalVar.health_ability += 1
		
	GlobalVar.point_player -= 3

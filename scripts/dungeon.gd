extends Node2D

#READY SISTEM
func _ready() -> void:
	_initialize_player_properties()

#RESET PROPERTY PLAYER
func _initialize_player_properties() -> void:
	GlobalVar.current_waves = 1
	GlobalVar.apple = 0
	GlobalVar.skull = 0
	GlobalVar.health_count = 0

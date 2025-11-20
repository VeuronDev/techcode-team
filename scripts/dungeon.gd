extends Node2D

func _ready() -> void:
	_initialize_player_properties()

func _initialize_player_properties() -> void:
	GlobalVar.current_waves = 1
	GlobalVar.apple = 0
	GlobalVar.skull = 0
	GlobalVar.health_count = 0

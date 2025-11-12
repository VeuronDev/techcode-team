extends CanvasLayer

@onready var HealthPlayer = $HealthPlayer
@onready var enemy_left = $enemy_count
@onready var waves_info = $waves_info

func _ready() -> void:
	HealthPlayer.value = GlobalVar.healthPlayer
	waves_info.text = "Wave: %d" % GlobalVar.current_waves
	enemy_left.text = "Enemies : %d" % GlobalVar.enemies_alive

func _process(delta: float) -> void:
	HealthPlayer.value = GlobalVar.healthPlayer
	waves_info.text = "Wave: %d" % GlobalVar.current_waves
	enemy_left.text = "Enemies : %d" % GlobalVar.enemies_alive

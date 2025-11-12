extends CanvasLayer

@onready var HealthPlayer = $HealthPlayer
@onready var enemy_left = $enemy_count
@onready var waves_info = $waves_info

func _ready() -> void:
	HealthPlayer.value = GlobalVar.healthPlayer
	waves_info.text = "Wave: %d" % GlobalVar.current_waves
	enemy_left.text = "Enemies: %d" % GlobalVar.enemies_alive
	GlobalVar.connect("wave_updated", Callable(self, "_on_wave_updated"))
	GlobalVar.connect("enemy_updated", Callable(self, "_on_enemy_updated"))

func _process(delta: float) -> void:
	HealthPlayer.value = GlobalVar.healthPlayer

func _on_wave_updated():
	waves_info.text = "Wave: %d" % GlobalVar.current_waves

func _on_enemy_updated():
	enemy_left.text = "Enemies: %d" % GlobalVar.enemies_alive

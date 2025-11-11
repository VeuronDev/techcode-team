extends CanvasLayer

@onready var HealthPlayer = $HealthPlayer

func _ready() -> void:
	HealthPlayer.value = GlobalVar.healthPlayer
	
func _process(delta: float) -> void:
	HealthPlayer.value = GlobalVar.healthPlayer

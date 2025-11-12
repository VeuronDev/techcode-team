extends CanvasLayer

@onready var HealthPlayer = $HealthPlayer
@onready var enemy_left = $enemy_count
@onready var waves_info = $waves_info
@onready var countdown_label = $CountDown
@onready var apple = $apple

func _ready() -> void:
	HealthPlayer.value = GlobalVar.healthPlayer
	waves_info.text = "Wave: %d" % GlobalVar.current_waves
	enemy_left.text = "Enemies : %d" % GlobalVar.enemies_alive

func _process(delta: float) -> void:
	HealthPlayer.value = GlobalVar.healthPlayer
	apple.text = "%d"%GlobalVar.apple
	if GlobalVar.current_waves > 5:
		waves_info.text = "Wave Ended!"
		enemy_left.text = "No Enemy remains!"
		countdown_label.text = ""
	else:
		waves_info.text = "Wave: %d" % GlobalVar.current_waves
		enemy_left.text = "Enemies : %d" % GlobalVar.enemies_alive
		if GlobalVar.enemies_alive <= 0 and GlobalVar.TIMER_CHANGE_WAVES > 0:
			countdown_label.text = "Next wave in %d..." % GlobalVar.TIMER_CHANGE_WAVES
		else:
			countdown_label.text = ""

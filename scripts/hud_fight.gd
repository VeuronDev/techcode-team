extends CanvasLayer

@onready var HealthPlayer = $HealthPlayer
@onready var enemy_left = $enemy_count
@onready var waves_info = $waves_info
@onready var countdown_label = $CountDown
@onready var apple = $apple
@onready var log_player = $log_player
@onready var log_input = $log_input

func _ready() -> void:
	GlobalVar.connect("log_added", Callable(self, "_on_log_added"))
	HealthPlayer.value = GlobalVar.healthPlayer
	waves_info.text = "Wave: %d" % GlobalVar.current_waves
	enemy_left.text = "Enemies : %d" % GlobalVar.enemies_alive

func _process(_delta: float) -> void:
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


func _input(event):
	if event is InputEventKey and event.pressed:
		var key_name = OS.get_keycode_string(event.keycode)
		log_input.text = "Value : " + key_name
		
func _on_log_added(text: String):
	var label = Label.new()
	label.text = text
	label.modulate = Color(1, 1, 1, 0)
	label.add_theme_color_override("font_color", Color(1.0, 1.0, 0.941, 0.871))
	label.position = Vector2(0, 100)
	log_player.add_child(label)

	var appear_tween = create_tween()
	appear_tween.tween_property(label, "modulate:a", 1, 0.3)
	appear_tween.tween_property(label, "position:y", log_player.get_child_count() * 22, 0.3)

	for i in range(log_player.get_child_count()):
		var child = log_player.get_child(i)
		if is_instance_valid(child):
			var tween_move = create_tween()
			tween_move.tween_property(child, "position:y", i * 22, 0.3)
	if log_player.get_child_count() > 4:
		var oldest = log_player.get_child(0)
		if is_instance_valid(oldest):
			var fade_out = create_tween()
			fade_out.tween_property(oldest, "modulate:a", 0, 0.3)
			fade_out.tween_property(oldest, "position:y", -5, 0.3)
			fade_out.finished.connect(func():
				if is_instance_valid(oldest):
					oldest.queue_free()
			)

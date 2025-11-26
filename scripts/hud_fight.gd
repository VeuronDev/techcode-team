extends CanvasLayer

#PROPERTY NODE
@onready var HealthPlayer = $HealthPlayer
@onready var ExpPlayer = $ExpPlayer
@onready var waves_info = $waves_info
@onready var apple = $apple
@onready var skull = $skull
@onready var health = $health
@onready var log_player = $log_player
@onready var log_input = $log_input
@onready var point_player = $count_point
@onready var timer = $timer_waves

@onready var player = get_tree().get_first_node_in_group("Player")


#READY SISTEM
func _ready() -> void:
	GlobalVar.connect("log_added", Callable(self, "_on_log_added"))
	HealthPlayer.value = GlobalVar.healthPlayer
	waves_info.text = "Wave: %d" % GlobalVar.current_waves
	GlobalVar.connect("wave_timer_updated", Callable(self, "_on_timer_update"))


func _on_timer_update(value):
	timer.text = "Next Wave: %ds" % value
	
#LOOP MENGECEK INFORMASI PLAYER
func _process(_delta: float) -> void:
	ExpPlayer.value = GlobalVar.expPlayer
	HealthPlayer.value = GlobalVar.healthPlayer
	apple.text = "%d"%GlobalVar.apple
	health.text = "%d"%GlobalVar.health_count
	skull.text = "%d"%GlobalVar.skull
	point_player.text = " Point : %d"%GlobalVar.point_player
	if GlobalVar.current_waves > 5:
		waves_info.text = "Wave Ended!"
	else:
		if GlobalVar.current_waves < 5:
			waves_info.text = "Wave : %d/5" % GlobalVar.current_waves
		else:
			waves_info.text = "Last Wave!"

#MENGECEK VALUE HOTKEY USER
func _input(event):
	if event is InputEventKey and event.pressed:
		var key_name = OS.get_keycode_string(event.keycode)
		log_input.text = "Value : " + key_name

#MENAMBAHKAN LOG TEXT PLAYER
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

#BUTTON MENU DI TEKAN
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/property/main_game.tscn")

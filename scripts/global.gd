extends Node

var attack_active = false
var hurt_active = true
var healthPlayer = 100
var apple = 0
var skull = 0
var apple_taken = false
var health_taken = false
var skull_taken = false
var current_waves = 1
var waves_active = false
var kill_count = 0
var combo_timer: Timer
var combo_duration = 5.0
signal show_kill_message(text: String)

func _ready():
	combo_timer = Timer.new()
	combo_timer.one_shot = true
	combo_timer.wait_time = combo_duration
	add_child(combo_timer)
	combo_timer.connect("timeout", Callable(self, "_on_combo_timeout"))
func add_kill():
	kill_count += 1
	combo_timer.start()
	match kill_count:
		3:
			emit_signal("show_kill_message", "🔥 TRIPLE KILL!")
		5:
			emit_signal("show_kill_message", "💥 UNSTOPPABLE!")
		8:
			emit_signal("show_kill_message", "👑 GODLIKE!")
		_:
			emit_signal("show_kill_message", "☠️ Kill x%d" % kill_count)
func _on_combo_timeout():
	kill_count = 0

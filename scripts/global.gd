extends Node

signal wave_updated
signal enemy_updated
signal show_kill_message(text)
signal log_added(text)
signal wave_timer_updated(value)

@onready var spawn_point_scene = preload("res://scenes/characters/spawn_enemy.tscn")
@onready var spawn_boss = preload("res://scenes/characters/giant_goblin.tscn")
@onready var WinUI = preload("res://scenes/property/win.tscn")
@onready var LoseUI = preload("res://scenes/property/lose.tscn")

# VAR
var attack_active = false 
var hurt_active = true 
var apple_taken = false 
var health_taken = false 
var skull_taken = false
var current_waves = 1
var enemies_alive = 0
var waves_active = false
var Is_boss_alive = false
var kill_count = 0
var logs = []
var is_loading = false
var is_dead = false

const ENEMIES_PER_WAVE = 4
var TIMER_CHANGE_WAVES = 0.0

var combo_duration = 5.0
var combo_timer: Timer

var expPlayer = 0 
var apple = 0 
var skull = 0 
var health_count = 0
var point_player = 0
var attack_ability = 1
var defend_ability = 1
var health_ability = 1
var healthPlayer = 100 * health_ability

func _ready():
	combo_timer = Timer.new()
	combo_timer.one_shot = true
	combo_timer.wait_time = combo_duration
	add_child(combo_timer)
	combo_timer.timeout.connect(_on_combo_timeout)

	start_wave_with_timer() # mulai wave pertama


# -----------------------------------------
# ⛔ WAVE HANYA DIGANTI OLEH TIMER
# -----------------------------------------
func start_wave_with_timer():
	emit_signal("wave_updated")
	logPlayer("🔥 Wave %d started!" % current_waves)

	var wave_time = get_wave_timer(current_waves)
	TIMER_CHANGE_WAVES = wave_time

	var countdown_timer = Timer.new()
	countdown_timer.wait_time = 1
	countdown_timer.one_shot = false
	add_child(countdown_timer)
	countdown_timer.start()
	countdown_timer.timeout.connect(func():
		TIMER_CHANGE_WAVES -= 1
		emit_signal("wave_timer_updated", TIMER_CHANGE_WAVES)
		if TIMER_CHANGE_WAVES <= 0:
			countdown_timer.stop()
			countdown_timer.queue_free()
			var needed = get_required_point(current_waves)
			if point_player < needed:
				logPlayer("❌ Wave %d failed! Not enough points (%d/%d)" % [
					current_waves, point_player, needed
				])
				var lose = LoseUI.instantiate()
				get_node("/root/Tilemap").add_child(lose)
				pass 
				return
			get_tree().change_scene_to_file("res://scenes/property/rest_area.tscn")
	)


# -----------------------------------------
# NEXT WAVE LOGIC
# -----------------------------------------
func start_next_wave():
	if current_waves >= 5:
		logPlayer("🎉 All waves completed!")
		var win = WinUI.instantiate()
		get_node("/root/Tilemap").add_child(win)
		return 
	current_waves += 1
	emit_signal("wave_updated")
	logPlayer("⏳ Wave %d will start NOW!" % current_waves)
	# Setelah spawn → timer jalan lagi
	start_wave_with_timer()


# -----------------------------------------
# MUSUH HABIS TIDAK NGAPA-NGAPAIN
# -----------------------------------------
func enemy_died():
	enemies_alive -= 1
	add_kill()
	emit_signal("enemy_updated")

	# ❌ TIDAK ADA reroll_wave()
	# Wave lanjut hanya lewat TIMER


# -----------------------------------------
# EXP + KILL EFFECT
# -----------------------------------------
func add_kill():
	kill_count += 1
	combo_timer.start()

	match kill_count:
		3: emit_signal("show_kill_message", "🔥 TRIPLE KILL!")
		5: emit_signal("show_kill_message", "💥 UNSTOPPABLE!")
		8: emit_signal("show_kill_message", "👑 GODLIKE!")
		_: emit_signal("show_kill_message", "☠️ Kill x%d" % kill_count)


func _on_combo_timeout():
	kill_count = 0


func logPlayer(text):
	logs.append(text)
	if logs.size() > 5:
		logs.pop_front()
	emit_signal("log_added", text)


func get_wave_timer(wave):
	match wave:
		1: return 30
		2: return 40
		3: return 50
		_: return 60
		
func get_required_point(wave):
	match wave:
		1: return 20
		2: return 30
		3: return 40
		4: return 50
		5: return 60

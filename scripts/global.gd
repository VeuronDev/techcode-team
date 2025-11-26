extends Node

signal wave_updated
signal log_added(text)
signal wave_timer_updated(value)

@onready var spawn_point_scene = preload("res://scenes/characters/spawn_enemy.tscn")
@onready var spawn_boss = preload("res://scenes/characters/giant_goblin.tscn")
@onready var WinUI = preload("res://scenes/property/win.tscn")
@onready var LoseUI = preload("res://scenes/property/lose.tscn")
@onready var menu_jeda = preload("res://scenes/property/menu_jeda.tscn")

# VAR
# Tambahkan timer di sini
var countdown_timer: Timer = Timer.new()
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
var start_new_timir = true
var is_lose = false
var tutor_step = true
var music = true
var menu_on = false

const ENEMIES_PER_WAVE = 4
var TIMER_CHANGE_WAVES = 0.0

var combo_duration = 5.0

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
	# Setup timer sekali di awal
	add_child(countdown_timer)
	countdown_timer.wait_time = 1
	countdown_timer.one_shot = false
	countdown_timer.timeout.connect(_on_countdown_timeout)

# -----------------------------------------
# ⛔ WAVE HANYA DIGANTI OLEH TIMER
# -----------------------------------------
func start_wave_with_timer():
	if countdown_timer.is_stopped():
		emit_signal("wave_updated")
		logPlayer("🔥 Wave %d started!" % current_waves)
		var wave_time = get_wave_timer(current_waves)
		TIMER_CHANGE_WAVES = wave_time
		countdown_timer.start()
	else:
		logPlayer("⚠️ Wave timer already running!")

func _on_countdown_timeout():
	TIMER_CHANGE_WAVES -= 1
	emit_signal("wave_timer_updated", TIMER_CHANGE_WAVES)
	if TIMER_CHANGE_WAVES <= 0:
		countdown_timer.stop()
		var needed = get_required_point(current_waves)
		if point_player < needed:
			logPlayer("❌ Wave %d failed! Not enough points (%d/%d)" % [
				current_waves, point_player, needed
			])
			is_lose = true
		else:
			get_tree().change_scene_to_file("res://scenes/property/laoding.tscn")


# -----------------------------------------
# NEXT WAVE LOGIC
# -----------------------------------------
func start_next_wave():
	if current_waves >= 5:
		logPlayer("🎉 All waves completed!")
		var win = WinUI.instantiate()
		get_node("/root/island_%d"%current_waves).add_child(win)
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

	# ❌ TIDAK ADA reroll_wave()
	# Wave lanjut hanya lewat TIMER

func logPlayer(text):
	logs.append(text)
	if logs.size() > 5:
		logs.pop_front()
	emit_signal("log_added", text)


func get_wave_timer(wave):
	match wave:
		1: return 100
		2: return 120
		3: return 150
		_: return 200
		
func get_required_point(wave):
	match wave:
		1: return 20
		2: return 30
		3: return 40
		4: return 50

func get_island_scene_path() -> String:
	match current_waves:
		1: return "res://scenes/property/island/island_1.tscn"
		2: return "res://scenes/property/island/island_2.tscn"
		3: return "res://scenes/property/island/island_3.tscn"
		4: return "res://scenes/property/island/island_4.tscn"
		_: return "res://scenes/property/island/island_1.tscn"



func reset_all():
	# Menghentikan timer yang mungkin sedang berjalan
	if countdown_timer.is_stopped() == false:
		countdown_timer.stop()
	attack_active = false 
	hurt_active = true 
	apple_taken = false 
	health_taken = false 
	skull_taken = false
	current_waves = 1
	enemies_alive = 0
	waves_active = false
	Is_boss_alive = false
	kill_count = 0
	logs = []
	is_loading = false
	is_dead = false
	is_lose = false
	start_new_timir = true
	TIMER_CHANGE_WAVES = 0.0
	expPlayer = 0 
	apple = 0 
	skull = 0 
	health_count = 0
	point_player = 0
	attack_ability = 1
	defend_ability = 1
	health_ability = 1
	logPlayer("Game state reset.")

extends Node

# ==========================
# === PLAYER STATUS ========
# ==========================
var attack_active = false
var hurt_active = true
var healthPlayer = 100
var apple = 0
var skull = 0
var apple_taken = false
var health_taken = false
var skull_taken = false

# ==========================
# === WAVE SYSTEM ==========
# ==========================
var current_waves = 1
var waves_active = false
var enemies_alive = 0
signal wave_updated
signal enemy_updated

# ==========================
# === KILL COMBO SYSTEM ====
# ==========================
var kill_count = 0
var combo_timer: Timer
var combo_duration = 5.0
signal show_kill_message(text: String)

# ==========================
# === SPAWN SYSTEM =========
# ==========================
@onready var spawn_point_scene = preload("res://scenes/characters/spawn_enemy.tscn")

func _ready():
	combo_timer = Timer.new()
	combo_timer.one_shot = true
	combo_timer.wait_time = combo_duration
	add_child(combo_timer)
	combo_timer.connect("timeout", Callable(self, "_on_combo_timeout"))

# ==========================
# === MAIN WAVE SYSTEM =====
# ==========================
func spawn_wave_enemies(player_pos: Vector2, waves: int):
	for i in waves:
		var spawn_point_enemy = spawn_point_scene.instantiate()
		var offset_x = randf_range(100.0 , 200.0)
		var offset_y = randf_range(100.0 , 200.0)
		var random_offset = Vector2(offset_x, offset_y)			
		spawn_point_enemy.global_position = player_pos + random_offset
		get_parent().add_child.call_deferred(spawn_point_enemy)
		spawn_point_enemy.name = "spawn_enemy_" + str(i + 1)
		print("spawn enemy on :", spawn_point_enemy.global_position)
	start_wave(waves)

func start_wave(enemy_count: int):
	current_waves += 1
	waves_active = true
	enemies_alive = enemy_count
	emit_signal("wave_updated")
	emit_signal("enemy_updated")

func enemy_died():
	if not waves_active:
		return
	enemies_alive -= 1
	add_kill()
	emit_signal("enemy_updated")
	if enemies_alive <= 0:
		end_wave()

func end_wave():
	waves_active = false
	emit_signal("wave_updated")
	print("Wave %d selesai!" % current_waves)

# ==========================
# === KILL COMBO SYSTEM ====
# ==========================
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

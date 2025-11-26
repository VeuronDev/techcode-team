extends Node

signal wave_updated
signal enemy_updated
signal show_kill_message(text)
signal log_added(text)
signal wave_timer_updated(value)

@onready var spawn_point_scene = preload("res://scenes/characters/spawn_enemy.tscn")
@onready var spawn_boss = preload("res://scenes/characters/giant_goblin.tscn")

var attack_active = false
var hurt_active = true
var apple_taken = false
var health_taken = false
var skull_taken = false

var healthPlayer = 200
var expPlayer = 0
var apple = 0
var skull = 0
var health_count = 0

var TIMER_CHANGE_WAVES = 3.0
const ENEMIES_PER_WAVE = 4
var combo_duration = 5.0

var current_waves = 1
var enemies_alive = 0
var kill_count = 0
var point_player = 0
var waves_active = false
var Is_boss_alive = false

var combo_timer: Timer
var logs = []


func _ready():
	combo_timer = Timer.new()
	combo_timer.one_shot = true
	combo_timer.wait_time = combo_duration
	add_child(combo_timer)
	combo_timer.connect("timeout", Callable(self, "_on_combo_timeout"))


func logPlayer(text):
	logs.append(text)
	if logs.size() > 5:
		logs.pop_front()
	emit_signal("log_added", text)


func start_wave(enemy_count):
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

	if enemies_alive <= 0 and not Is_boss_alive:
		reroll_wave()

func reroll_wave():
	waves_active = false
	if current_waves >= 10:
		logPlayer("🎉 All 10 waves completed!")
		return
	current_waves += 1
	emit_signal("wave_updated")
	var wave_time = get_wave_timer(current_waves)
	logPlayer("⏳ Next wave (%d) in %d seconds..." % [current_waves, wave_time])
	var countdown_timer = Timer.new()
	countdown_timer.wait_time = 1
	countdown_timer.one_shot = false
	add_child(countdown_timer)
	countdown_timer.start()
	var time_left = wave_time
	countdown_timer.timeout.connect(func():
		time_left -= 1
		TIMER_CHANGE_WAVES = time_left
		emit_signal("wave_timer_updated", time_left)

		if time_left <= 0:
			countdown_timer.stop()
			countdown_timer.queue_free()

			var next_enemy_count = ENEMIES_PER_WAVE + (current_waves - 1) * 2
			var spawn_manager = get_tree().get_first_node_in_group("spawn_manager_group")

			if is_instance_valid(spawn_manager):
				spawn_manager.spawn_random_enemies(next_enemy_count)
				waves_active = true

				if current_waves == 10:
					Is_boss_alive = true
					var boss = spawn_boss.instantiate()
					boss.position = Vector2(650, 395)
					get_node("/root/dungeon/").add_child(boss)
			else:
				print("ERROR: Spawn Manager not found!")
	)


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


func add_exp_player():
	expPlayer += randi_range(1,5)


func get_wave_timer(wave):

	match wave:
		1: return 120
		2: return 90
		3: return 60
		_: return 60

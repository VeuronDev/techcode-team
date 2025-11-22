extends Node

#CALL SCENES PROPERTY
@onready var spawn_point_scene = preload("res://scenes/characters/spawn_enemy.tscn")
@onready var spawn_boss = preload("res://scenes/characters/giant_goblin.tscn")

#PLAYER PROPERTY
var attack_active: bool = false
var hurt_active: bool = true
var apple_taken: bool = false
var health_taken: bool = false
var skull_taken: bool = false
var healthPlayer: int = 200
var expPlayer: int = 0
var apple: int = 0
var skull: int = 0
var health_count: int = 0

#SYSTEM PROPERTY
var TIMER_CHANGE_WAVES: float = 3.0
const ENEMIES_PER_WAVE: int = 4
var combo_duration: float = 5.0
var current_waves: int = 1
var enemies_alive: int = 0
var kill_count: int = 0
var waves_active: bool = false
var Is_boss_alive: bool = false
signal wave_updated
signal enemy_updated
var combo_timer: Timer
signal show_kill_message(text: String)
signal log_added(text: String)
var logs: Array = []

#READY SISTEM
func _ready() -> void:
	combo_timer = Timer.new()
	combo_timer.one_shot = true
	combo_timer.wait_time = combo_duration
	add_child(combo_timer)
	combo_timer.connect("timeout", Callable(self, "_on_combo_timeout"))

#LOG TEXT PLAYER 
func logPlayer(text: String) -> void:
	logs.append(text)
	if logs.size() > 5:
		logs.pop_front()
	emit_signal("log_added", text)

#SPAWN ENEMY BERDASARKAN POSISI PLAYER
func spawn_wave_enemies(player_pos: Vector2) -> void:
	for i in range(current_waves):
		var spawn_point_enemy = spawn_point_scene.instantiate()
		var offset_x = randf_range(10.0, 30.0)
		var offset_y = randf_range(10.0, 30.0)
		var random_offset = Vector2(offset_x, offset_y)		
		spawn_point_enemy.global_position = player_pos + random_offset
		get_node("/root/game/").add_child.call_deferred(spawn_point_enemy)
		spawn_point_enemy.name = "spawn_enemy_" + str(i + 1)		
	start_wave(current_waves)

#START WAVE
func start_wave(enemy_count: int) -> void:
	waves_active = true
	enemies_alive = enemy_count
	emit_signal("wave_updated")
	emit_signal("enemy_updated")

#SAAT MUSUH HABIS DI CURRENT WAVE
func enemy_died() -> void:
	if not waves_active:
		return
	enemies_alive -= 1
	add_kill()
	emit_signal("enemy_updated")
	if enemies_alive <= 0 and not Is_boss_alive:
		reroll_wave()

#MELANJUTKAN CURRENT WAVE
func reroll_wave() -> void:
	waves_active = false
	current_waves += 1
	emit_signal("wave_updated")
	GlobalVar.logPlayer("⏭️ Next wave to %d ..." % GlobalVar.current_waves)
	TIMER_CHANGE_WAVES = 3
	var countdown_timer = Timer.new()
	countdown_timer.wait_time = 1.0
	countdown_timer.one_shot = false
	countdown_timer.name = "WaveCountdownTimer"
	add_child(countdown_timer)
	countdown_timer.start()
	countdown_timer.timeout.connect(func():
		TIMER_CHANGE_WAVES -= 1
		if TIMER_CHANGE_WAVES <= 0:
			countdown_timer.stop()
			countdown_timer.queue_free()
			var next_enemy_count = ENEMIES_PER_WAVE + (current_waves - 1) * 2
			var spawn_manager = get_tree().get_first_node_in_group("spawn_manager_group")
			if is_instance_valid(spawn_manager):
				spawn_manager.spawn_random_enemies(next_enemy_count)
				waves_active = true
				if current_waves == 5:
					Is_boss_alive = true
					var boss = spawn_boss.instantiate()
					var offset_x = randf_range(10.0, 30.0)
					var offset_y = randf_range(10.0, 30.0)
					var random_offset = Vector2(offset_x, offset_y)        
					boss.position = Vector2(650, 395) + random_offset
					get_node("/root/dungeon/").add_child(boss)
					boss.name = "spawn_enemy_boss"
			else:
				print("ERROR: Spawn Manager not found!")
	)

#KILL NOTIFIKASI BERDASARKAN KILL COUNT
func add_kill() -> void:
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

#RESET KILL COUNT
func _on_combo_timeout() -> void:
	kill_count = 0

#MENAMBAHKAN EXP PLAYER
func add_exp_player() -> void:
	expPlayer += randi_range(1,5)

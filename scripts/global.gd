extends Node

var attack_active = false
var hurt_active = true
var healthPlayer = 100
var apple = 0

#drop item count
func dropped_item_count(enemy_level : int, Item : int) -> int:
	if enemy_level < 10:
		pass
	elif enemy_level > 10:
		pass
	return Item

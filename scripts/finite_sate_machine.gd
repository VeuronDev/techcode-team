extends Node2D

#PROPERTY STATE
var current_state = State
var previous_state = State

#READY SISTEM
func _ready() -> void:
	current_state = get_child(0) as State
	previous_state = current_state
	current_state.enter()

#MENGUBAH STATE
func change_state(state) -> void:
	current_state = find_child(state) as State
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
	

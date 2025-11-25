extends Node2D
class_name State

#PROPERTY NODE
@onready var debug = owner.find_child("debug")
@onready var player = owner.get_parent().find_child("player")
@onready var animation_player = owner.find_child("AnimationPlayer")

#READY SISTEM
func _ready() -> void:
	set_physics_process(false)

#SET FISIK KE TRUE
func enter() -> void:
	set_physics_process(true)

#SET FISIK KE FALSE
func exit() -> void:
	set_physics_process(false)
	
#TRANSISI OPTION
func transition() -> void:
	pass
	
#LOOP CEK TRANSISI
func _physics_process(_delta) -> void:
	transition()
	debug.text = name
	

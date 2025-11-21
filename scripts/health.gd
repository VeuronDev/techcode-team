extends Area2D

#PROPERTY NODE
@onready var animate = $health_image/animation
@onready var collect = $collect_item

#READY SISTEM
func _ready() -> void:
	animate.play("health_spawn")

#KETIKA HEALTH DI AREA PLAYER
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalVar.health_taken = true
		GlobalVar.healthPlayer += 30
		GlobalVar.health_count += 1
		collect.play()
		GlobalVar.logPlayer("➕ Recovering player 30+ Health.")
		animate.play("health_taken")

#MENUNGGU ANIMASI SELESAI
func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "health_taken":
		GlobalVar.health_taken = false
		queue_free()

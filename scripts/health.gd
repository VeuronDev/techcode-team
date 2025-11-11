extends Area2D

@onready var animate = $health_image/animation

func _ready() -> void:
	animate.play("health_spawn")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalVar.health_taken = true
		GlobalVar.healthPlayer += 30
		animate.play("health_taken")
		
func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "health_taken":
		GlobalVar.health_taken = false
		queue_free()

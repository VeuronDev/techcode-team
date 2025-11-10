extends Area2D

@onready var animate = $apple_image/animation

func _ready() -> void:
	animate.play("apple_spawn")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalVar.apple_taken = true
		GlobalVar.apple += 1
		animate.play("apple_taken")
		
func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "apple_taken":
		GlobalVar.apple_taken = false
		queue_free()

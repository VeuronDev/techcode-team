extends Area2D

@onready var animate = $apple_image/animation
@onready var collect = $collect_item

func _ready() -> void:
	animate.play("apple_spawn")
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalVar.apple_taken = true
		collect.play()
		GlobalVar.apple += 1
		GlobalVar.logPlayer("➕ Added item apple 1+ to backpack.")
		animate.play("apple_taken")
func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "apple_taken":
		GlobalVar.apple_taken = false
		queue_free()

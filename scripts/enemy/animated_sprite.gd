extends AnimatedSprite2D

func play_idle():
	%SpriteAnimation.play("idle")
	
func play_walk():
	%SpriteAnimation.play("walk")
	
func play_hurt():
	%SpriteAnimation.play("hurt")

func play_death():
	%SpriteAnimation.play("death")
	
func play_attack():
	%SpriteAnimation.play("attack")
	

extends CharacterBody2D
class_name Enemy1
@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	move_and_slide()
	
	if (velocity.x > 1 || velocity.x < -1):
		#animated_sprite_2d.animation = "run"
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

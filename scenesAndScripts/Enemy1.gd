extends CharacterBody2D
class_name Enemy1
@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	move_and_slide()


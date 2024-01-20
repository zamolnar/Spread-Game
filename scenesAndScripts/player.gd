extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var speed = 200
var move_direction : Vector2 = Vector2.ZERO

	
func _physics_process(delta):
	if (velocity.x > 1 || velocity.x < -1):
		#animated_sprite_2d.animation = "run"
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	move_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity.x = move_direction.x * speed;
	velocity.y = move_direction.y * speed;
	move_and_slide()
	
	#to be modified with non placeholder frog
	
	if(velocity.x < 0):
		animated_sprite_2d.flip_h = true
	if (velocity.x > 0):
		animated_sprite_2d.flip_h = false	


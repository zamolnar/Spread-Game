extends CharacterBody2D

@export var speed = 400
var move_direction : Vector2 = Vector2.ZERO

	
func _physics_process(delta):
	move_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity.x = move_direction.x * speed;
	velocity.y = move_direction.y * speed;
	move_and_slide()

extends CharacterBody2D

@export var speed = 400

func _physics_process(_delta):
# Get Input direction from input map then adjust velocities accordingly
	var move_direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	velocity.x = move_direction.x * speed
	velocity.y = move_direction.y * speed

	move_and_slide()

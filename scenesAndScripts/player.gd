extends CharacterBody2D

@export var speed = 400

#func _character_spawn():
	

func _physics_process(_delta):
# Get Input direction from input map then adjust velocities accordingly
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("d"):
		velocity.x += 1
	if Input.is_action_pressed("a"):
		velocity.x -= 1
	if Input.is_action_pressed("w"):
		velocity.y += 1
	if Input.is_action_pressed("s"):
		velocity.y -= 1	
	

	move_and_slide()

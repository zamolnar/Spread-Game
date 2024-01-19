extends CharacterBody2D

@export var speed = 400
	
func _physics_process(delta):
	if Input.is_action_pressed('Left'):
		velocity.x = speed
	if Input.is_action_pressed('Right'):
		velocity.x = speed
	if Input.is_action_pressed('Up'):
		velocity.y = speed
	if Input.is_action_pressed('Down'):
		velocity.y = -speed
		
	move_and_slide()

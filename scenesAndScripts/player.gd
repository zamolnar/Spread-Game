extends CharacterBody2D

@export var speed = 400
	
func _physics_process(delta):
	if Input.is_action_pressed('ui_left'):
		velocity.x = -speed
	if Input.is_action_pressed('ui_right'):
		velocity.x = speed
	if Input.is_action_pressed('ui_up'):
		velocity.y = -speed		#y==0 is the top
	if Input.is_action_pressed('ui_down'):
		velocity.y = speed
		
	move_and_slide()

extends CharacterBody2D

@export var speed = 400

func _physics_process(delta):
	
	if Input.is_key_pressed(KEY_W):
		position.y -= speed * delta
	if Input.is_key_pressed(KEY_S):
		position.y += speed * delta
	if Input.is_key_pressed(KEY_A):
		position.x -= speed * delta
	if Input.is_key_pressed(KEY_D):
		position.x += speed * delta
	
	move_and_slide()

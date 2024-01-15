extends CharacterBody2D

@export var speed = 400

var move_direction : Vector2 = Vector2.ZERO

func _physics_process(_delta):
# Get Input direction from input map then adjust velocities accordingly
	move_direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	velocity.x = move_direction.x * speed
	velocity.y = move_direction.y * speed
	
# Old code	------------------------
#	if Input.is_key_pressed(KEY_W):
#		position.y -= speed * delta
#	if Input.is_key_pressed(KEY_S):
#		position.y += speed * delta
#	if Input.is_key_pressed(KEY_A):
#		position.x -= speed * delta
#	if Input.is_key_pressed(KEY_D):
#		position.x += speed * delta

	move_and_slide()

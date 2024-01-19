extends State
class_name Enemy1Idle
@onready var animated_sprite_2d = $"../../AnimatedSprite2D"

#state exports
@export var enemy1: CharacterBody2D
@export var move_speed := 200

#state variables
var move_direction : Vector2
var wander_time : float

#override inherited methods
func Enter():
	randomize_wander()


func State_Update(delta: float):
	animated_sprite_2d.play("idle")
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()


func State_Physics_Update(delta: float):
	if enemy1:
		enemy1.velocity = move_direction * move_speed


#methods specific to idle
func randomize_wander():
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1,5)



extends Enemy1State
class_name Enemy1Idle

#export all other states that this one can reach
@export var Enemy1Follow: Enemy1State

#state variables
var move_direction
var wander_time

#override parent enter() function with state specific logic
func enter() -> void:
	super()
	randomize_wander()
#calling super utilizes the parent classes enter() // which contains the animation

func process_physics(delta: float) -> Enemy1State:
	wander_time -= delta
	Enemy1.velocity = move_direction * move_speed
	#Enemy1.move_and_slide()
	return null


func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1,5)

extends Node
class_name Enemy1_FSM
#this class is designed to handle state transitioning for enemy1

@export var initial_state : Enemy1State
@export var current_state : Enemy1State

#initalize the state machine by giving each child state a reference to the parent object it belongs to and enter the default starting_state
func init(parent: Enemy1) ->void:
	for child in get_children():
		child.parent = parent
	change_state(initial_state)

#exit logic, then enter logic
func change_state(new_state: Enemy1State):
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

#update state input
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

#update state frame
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

#update state physics
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

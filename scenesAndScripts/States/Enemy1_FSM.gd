extends Node
class_name FSM

#this class is designed to handle state transitioning
#for enemy1


#variables for storing/managing states
@export var initial_state : State

# Container for all possible enemy 1 states
var states: Dictionary = {}
var current_state : State

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child

#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.State_Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.State_Physics_Update(delta)


func _on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state


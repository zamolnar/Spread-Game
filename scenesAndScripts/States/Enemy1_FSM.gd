extends Node

class_name Enemy1FSM

@export var initial_state : State

var states: Dictionary = {}
var current_state : State


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child


func _process(delta):
	if current_state:
		current_state.Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)


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






#--------------------------------------------------------------------------
#@export var current_state : EnemyState
#@export var enemy : CharacterBody2D
#@export var animation_tree : AnimationTree
#
#var states : Array[EnemyState]
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#for child in get_children():
		#if(child is EnemyState):
			#states.append(child)
			#
			## set up states with variables they need
			#child.enemy = enemy
			#child.playback = animation_tree["parameters/playback"]
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#if(current_state.next_state != null):
		#switch_states(current_state.next_state)
		#
		#current_state.state_process(_delta)
		## checks for next_state and calls the cleanup function
		#
		#
## Accessors for state variables
#func check_if_can_move():
	#return current_state.can_move
#func check_speed():
	#return current_state.speed
#
## Functions
#func switch_states(new_state : EnemyState):
	#if (current_state != null):
		#current_state.on_exit()
		#current_state.next_state = null
		#
	#current_state = new_state
	#current_state.on_enter()
	## calls all the state specific enter/exit functions and cleans up

extends Node
class_name State

#this class is at the top of the inheritance
#it contains methods all methods that states can use
#some states are forced to override these methods (on purpose)

#call when swapping states
signal Transitioned


func Enter():
	pass


func Exit():
	pass


func State_Update(_delta: float):
	pass


func State_Physics_Update(_delta: float):
	pass









#--------------------------------------------------------------------------------------
#@export var can_move : bool = true
#@export var speed : float = 100.0
	## default values, change for each state.gd
#
#var enemy : CharacterBody2D
	## set within the FSM, this is the enemy physics node
#var next_state : EnemyState = null 
	## change this within a state function to call this state's on_exit and the next state's on_enter
#var playback : AnimationNodeStateMachinePlayback 
	## to handle animation playback
#
#func state_process(_delta):
	#pass
#
#func state_input(event : InputEvent):
	#pass
	## more useful for player/meta states (pausing, menu navigation)
	#
#func on_enter():
	#pass
	## set animations, activate hitboxes
	#
#func on_exit():
	#pass
	## deactivate hitboxes
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

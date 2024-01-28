extends CharacterBody2D
class_name Enemy1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var state_machine = $Enemy1_FSM

#the idea is that we will let the state machine handle the enemy processes

func _ready() -> void:
	#initialize state machine, passing reference of the player to the states
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

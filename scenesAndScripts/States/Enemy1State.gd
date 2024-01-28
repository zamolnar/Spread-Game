extends Node
class_name Enemy1State

#this class is at the top of the inheritance
#it contains methods all methods that states can use
#some states are forced to override these methods (on purpose)

@export var animation_name: String
@export var move_speed: float = 200

var parent: Enemy1

func enter() -> void:
	parent.animated_sprite_2d.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> Enemy1State:
	return null

func process_frame(delta: float) -> Enemy1State:
	return null

func process_physics(delta: float) -> Enemy1State:
	return null

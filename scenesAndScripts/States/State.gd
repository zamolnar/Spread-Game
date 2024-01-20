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


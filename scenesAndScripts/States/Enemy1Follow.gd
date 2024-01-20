extends State
class_name Enemy1Follow

@export var enemy: CharacterBody2D
@export var move_speed := 200
var player: CharacterBody2D

func Enter():
	player= get_tree().get_first_node_in_group("Player")
	
func State_Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
	
	if direction.length() > 50:
		Transitioned.emit(self, "Enemy1Idle")

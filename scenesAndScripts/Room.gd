extends RigidBody2D

var size

func room_create(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()	#looks like a rectangle
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s		#hitbox like a rectangle

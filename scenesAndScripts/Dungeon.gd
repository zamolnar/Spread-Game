extends Node2D

var Room = preload("res://scenesAndScripts/Room.tscn")

var tile_size = 32		#size of tiles from tilemap
var num_rooms = 50		#number rooms for initial generate (gets cut down later)
var min_size = 4		#smallest possible length for width/height
var max_size = 10		#largest possible length for width/height
var horizontalSpread = 400		#biases horizontal generation over vertical 
var theEarthquake = 0.5		#randomly destroys this percent of the rooms (providing better spread)

func _ready():
	randomize()
	create_rooms()
	
func create_rooms():
	for i in range(num_rooms):
		var pos = Vector2(randi_range(-horizontalSpread, horizontalSpread),0)						#the origin of the 2d plane, position is already a keyword so use pos
		var roomInstance = Room.instantiate()			#a room...
		var width = min_size + randi() % (max_size - min_size)		#random size between min and max
		var height = min_size + randi() % (max_size - min_size)		#random size between min and max
		roomInstance.room_create(pos, Vector2(width,height)* tile_size)	#room create
		$Rooms.add_child(roomInstance)		#keep track of rooms in a list
	
#wait for engine to finish spreading rooms out
	await get_tree().create_timer(1).timeout
# remove rooms (possibly)
	for room in $Rooms.get_children():
		if randf() < theEarthquake:
			room.queue_free()		#remove the room
		else:
			room.freeze = true		#hold the room still


func _draw():			#strictly for visualizing
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size*2), #room sized rectangle
		Color(0,128,128), false)			#teal color, not filled in

func _process(delta):
	queue_redraw()

func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in $Rooms.get_children():
			n.queue_free()
		create_rooms()

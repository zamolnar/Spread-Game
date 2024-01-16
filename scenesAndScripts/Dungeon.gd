extends Node2D

var Room = preload("res://scenesAndScripts/Room.tscn")

var tile_size = 32		#size of tiles from tilemap
var num_rooms = 50		#number rooms for initial generate (gets cut down later)
var min_size = 4		#smallest possible length for width/height
var max_size = 10		#largest possible length for width/height
var horizontalSpread = 400		#biases horizontal generation over vertical 
var theEarthquake = 0.5		#randomly destroys this percent of the rooms (providing better spread)

var primPath	#AStar2D pathfinding object

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
	await get_tree().create_timer(1).timeout	#pause for rooms to spread out
# remove rooms (possibly)
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < theEarthquake:
			room.queue_free()		#remove the room
		else:
			room.freeze = true		#hold the room still
			room_positions.append(Vector2(	#add to pos list for Prims
				room.position.x, room.position.y)) #3d representation of 2d vector
	 
	await get_tree().create_timer(0.3).timeout	#pause for earthquake
	#generate a min spanning tree using Prim's algo
	primPath = find_mst(room_positions)


func _draw():			#strictly for visualizing
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size*2), #room sized rectangle
		Color(0,128,128), false)			#teal color, not filled in
		
	if primPath:
		for point in primPath.get_point_ids():
			for connection in primPath.get_point_connections(point):
				var pp = primPath.get_point_position(point)
				var cp = primPath.get_point_position(connection)
				draw_line(Vector2(pp.x,pp.y), Vector2(cp.x,cp.y),
							Color(255,200,50), 15, true)

func _process(delta):
	queue_redraw()


func _input(event):
	if event.is_action_pressed('ui_select'):		#regenerate (for testing)
		for n in $Rooms.get_children():
			n.queue_free()
		primPath = null
		create_rooms()


func find_mst(nodes):			#Prim's Algo--------------a pain in my ass
	var path = AStar2D.new()	#A*
	path.add_point(path.get_available_point_id(), nodes.pop_front())	#start at first node
#repeat for all nodes
	while nodes:					#for all remaining nodes
		var minDistance = INF
		var minPosition = null
		var currentPosition = null
	#loop through points in path
		for p1 in path.get_point_ids():		#get the next one
			var p_temp1 = path.get_point_position(p1)	#get its location
		#loop through remaining nodes
			for p2 in nodes:		#shuffle through the rest of the nodes
				if p_temp1.distance_to(p2) < minDistance:	#check for min distance
					minDistance = p_temp1.distance_to(p2)	
					minPosition = p2
					currentPosition = p_temp1		#update distance for every new min found
		var n = path.get_available_point_id()		#we found the min distance
		path.add_point(n, minPosition)				#add point to the route
		path.connect_points(path.get_closest_point(currentPosition), n)		#make the link
		nodes.erase(minPosition)	#take it out of the system
									#continue
	return path		#return the linked nodes when your done
	

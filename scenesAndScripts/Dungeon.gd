extends Node2D

#universal variables

#objects
var Room = preload("res://scenesAndScripts/Room.tscn")
@onready var Map = $TileMap
@onready var Player = preload("res://scenesAndScripts/player.tscn")
@onready var enemy1 = preload("res://scenesAndScripts/Enemy1.tscn")
var font = preload("res://Assets/placeholderArt/Roboto-Black.ttf")
var primPath	#AStar2D pathfinding object

#parameter variables
var tile_size = 32		#size of tiles from tilemap
var num_rooms = 5		#number rooms for initial generate (gets cut down later)
var min_size = 4		#smallest possible length for width/height
var max_size = 8		#largest possible length for width/height
var horizontalSpread = 300		#biases horizontal generation over vertical 
var theEarthquake = 0.5		#randomly destroys this percent of the rooms (providing better spread)

#playMode variables
var play_mode = false
var start_room = null
var boss_room = null
var player = null
var Enemy1 = null

#calls / instantiates on pressing play
func _ready():
	randomize()
	create_rooms()

#control flow for imaging
func _draw():			#strictly for visualizing
	if start_room:
		draw_string(font, 		#font
					start_room.position-Vector2(125,0), #pos
					"start", 	#text
					0, 			#alignment
					-1, 		#width
					52)			#font size
	if boss_room:
		draw_string(font, boss_room.position-Vector2(125,0), "boss", 0, -1, 52)
	if play_mode:
		return
	
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

#not sure but it is necessary
func _process(delta):
	queue_redraw()

#current control flow for testing
func _input(event):
	if event.is_action_pressed('ui_select'):		#regenerate
		if play_mode:
			player.queue_free()
			play_mode = false
		for n in $Rooms.get_children():
			n.queue_free()
		Map.clear()
		primPath = null
		start_room = null
		boss_room = null
		await get_tree().create_timer(0.5).timeout
		create_rooms()
		
	if event.is_action_pressed('ui_focus_next'):
		make_map()
		#find start and boss rooms
		find_start_room()
		find_boss_room()

#TESTING spawn enemies, needs work
	if event.is_action_pressed('ui_cancel'):
		player = Player.instantiate()
		add_child(player)
		player.position = start_room.position
		play_mode = true
		#Camera2D.align()
		#Camera2D.zoom(1,1)

	if event.is_action_pressed("right_click"):
		Enemy1 = enemy1.instantiate()
		add_child(Enemy1)
		Enemy1.position = player.position
		

#creates random floor layout, calls prims algo
func create_rooms():
	for i in range(num_rooms):
		var pos = Vector2(randi_range(-horizontalSpread, horizontalSpread),0)						#the origin of the 2d plane, position is already a keyword so use pos
		var roomInstance = Room.instantiate()			#a room...
		var width = min_size + randi() % (max_size - min_size)		#random size between min and max
		var height = min_size + randi() % (max_size - min_size)		#random size between min and max
		roomInstance.room_create(pos, Vector2(width,height)* tile_size)	#room create
		$Rooms.add_child(roomInstance)		#keep track of rooms in a list
	
	
#wait for engine to finish spreading rooms out
	await get_tree().create_timer(0.5).timeout	#pause for rooms to spread out
# remove rooms (possibly)
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < theEarthquake:
			room.queue_free()		#remove the room
		else:
			room.freeze = true		#hold the room still
			room_positions.append(Vector2(	#add to pos list for Prims
				room.position.x, room.position.y)) #3d representation of 2d vector
	
	await get_tree().create_timer(1).timeout	#pause for earthquake
	#generate a min spanning tree using Prim's algo
	primPath = find_mst(room_positions)

#Prim's Algo--------------a pain in my ass
func find_mst(nodes):
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

#activate after Prim's, finds start/boss rooms, covers everything in wall tiles
#then it calls carve
func make_map():
	#create tilemap from generated rooms and path
	Map.clear()
	
	#fill tilemap with walls
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size,	#the top left
						room.get_node("CollisionShape2D").shape.extents*2)	#full width
		full_rect = full_rect.merge(r)
		var topleft = Map.local_to_map(full_rect.position)
		var bottomright = Map.local_to_map(full_rect.end)
		for x in range(topleft.x-1, bottomright.x+2):
			for y in range(topleft.y-1, bottomright.y+2):
				Map.set_cell(0,			#layer ID
					Vector2i(x,y),		#coordinate x,y
					0,					#tile ID
					Vector2i(1,1))		#atlas coordinate (in tile set)
				
	#carve rooms and corridors
	var corridors = []		#one corridor per connection
	#rooms
	for room in $Rooms.get_children():
		var s = (room.size / (tile_size/2)).floor()
		#var pos = Map.local_to_map(room.position)
		var ul = (room.position / (tile_size/2)).floor() - s	#upper left of room
		for x in range(2, s.x * 2 - 1):			#starting at 2 allows adjacent rooms to have a wall b/w them
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(0,			#layer ID
					Vector2i(ul.x+ x, ul.y+ y),		#coordinate x,y
					0,					#tile ID
					Vector2i(7,1))		#atlas coordinate (in tile set)
		#corridors
		var p = primPath.get_closest_point(room.position)
		for conn in primPath.get_point_connections(p):
			if not conn in corridors:
				var start = Map.local_to_map(Vector2(primPath.get_point_position(p).x,
												primPath.get_point_position(p).y))
				var end = Map.local_to_map(Vector2(primPath.get_point_position(conn).x,
												primPath.get_point_position(conn).y))
				carve_path(start, end)
			corridors.append(p)

#inserts the walkable tiles amock the walls, then uses
#Prim's path to carve walkways between rooms
func carve_path(pos1, pos2):
	#carve path between 2 points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() %2)
	if y_diff == 0: y_diff = pow(-1.0, randi() %2)
	#choose direction // x then y or y then x
	var x_y = pos1
	var y_x = pos2
	if (randi() %2)>0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(0,			#layer ID
					Vector2i(x, x_y.y),		#coordinate x,y
					0,					#tile ID
					Vector2i(7,1))		#atlas coordinate (in tile set)
		#widen the corridor
		Map.set_cell(0,			#layer ID
					Vector2i(x, x_y.y +y_diff),		#coordinate x,y
					0,					#tile ID
					Vector2i(7,1))		#atlas coordinate (in tile set)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(0,			#layer ID
					Vector2i(y_x.x, y),		#coordinate x,y
					0,					#tile ID
					Vector2i(7,1))		#atlas coordinate (in tile set)
		#widen the corridor
		Map.set_cell(0,			#layer ID
					Vector2i(y_x.x +x_diff, y),		#coordinate x,y
					0,					#tile ID
					Vector2i(7,1))		#atlas coordinate (in tile set)

#currently finds leftmost room and makes it the start
func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

#currently finds rightmost room and makes it the boss
func find_boss_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			boss_room = room
			max_x = room.position.x

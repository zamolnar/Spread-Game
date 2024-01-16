extends Node2D

var Room = preload("res://scenesAndScripts/Room.tscn")

var tile_size = 32		#size of tiles from tilemap
var num_rooms = 50		#number rooms for initial generate (gets cut down later)
var min_size = 4		#smallest possible length for width/height
var max_size = 10		#largest possible length for width/height

func _ready():
	randomize()
	create_rooms()
	
func create_rooms():
	for i in range(num_rooms):
		var pos = Vector2(0,0)					#the origin of the 2d plane
		var roomInstance = Room.instance()		#a room...
		

extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	#set volume to 50 to not blast ears
	print(GlobalVar.MusicVol)
	
	AudioServer.set_bus_volume_db(3,linear_to_db(GlobalVar.MusicVol))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#function to call main scene from title screen
func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenesAndScripts/Dungeon.tscn")

#function to open settings scene from title
func _on_settings_button_pressed():
	GlobalVar.PrevScene = get_tree().current_scene.name
	get_tree().change_scene_to_file("res://scenesAndScripts/settings_screen.tscn")
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.

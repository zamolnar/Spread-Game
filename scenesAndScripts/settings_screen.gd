extends Node

#also got to change music depending on if the go into settings (Active vs Inactive)

func _ready():
	_on_max_volume_slider_value_changed(GlobalVar.MaxVol)
	$Control/MaxVolumeSlider.value = GlobalVar.MaxVol
	_on_music_volume_slider_value_changed(GlobalVar.MusicVol)
	$Control/MusicVolumeSlider.value = GlobalVar.MusicVol
	pass

#sets the bus volume by passing a float from slider into db value
func _set_bus_volume(bus_index: int, value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < .05)

#back to game
func _on_back_button_pressed():
	#return to prev scene
	print(GlobalVar.PrevScene)
	if (GlobalVar.PrevScene == "TitleScreen"):
		get_tree().change_scene_to_file("res://scenesAndScripts/Title_screen.tscn")
	if (GlobalVar.PrevScene == "Dungeon"):
		get_tree().change_scene_to_file("res://scenesAndScripts/Dungeon.tscn")
	pass # Replace with function body.

#quit out of game
func _on_quit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.

#return to main menu
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenesAndScripts/Title_screen.tscn")
	pass # Replace with function body.

#change max volume (change every audio bus)
func _on_max_volume_slider_value_changed(value):
	_set_bus_volume(0, value)
	pass # Replace with function body.

#change music volume related busses
func _on_music_volume_slider_value_changed(value) -> void:
	_set_bus_volume(1, value)
	_set_bus_volume(2, value)
	_set_bus_volume(3, value)
	_set_bus_volume(4, value)
	GlobalVar.MusicVol = value
	pass # Replace with function body.

#change ambient volume related busses
func _on_ambient_volume_slider_value_changed(value):
	pass # Replace with function body.

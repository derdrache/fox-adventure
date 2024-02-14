extends Control

signal close_window()

var normalSound = 25



func _on_close_button_pressed():
	emit_signal("close_window")
	visible = false

func _on_background_music_slider_value_changed(value):
	_change_volume(value, "BackgroundMusic")
	

func _on_sound_effect_slider_value_changed(value):
	_change_volume(value, "SoundEffect")

func _change_volume(value, bus):
	var valueInDB : int
	
	if value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), false)
		
		valueInDB = value - normalSound
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), valueInDB)	
		
	
	if bus == "BackgroundMusic": GameManager.backgroundMusicVolumen = valueInDB
	elif bus == "SoundEffect": GameManager.soundEffectsVolumen = valueInDB


func _on_texture_button_pressed():
	$AudioStreamPlayer2D.play()

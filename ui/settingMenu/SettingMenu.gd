extends Control

@onready var soundEffectSlider = $"TextureRect/VBoxContainer/Sound Effects/SoundEffectSlider"
@onready var backgroundMusicSlider = $"TextureRect/VBoxContainer/Background Music/BackgroundMusicSlider"

var soundMinValue : int

signal close_window()

func _ready():
	soundMinValue = soundEffectSlider.min_value

func _on_close_button_pressed():
	emit_signal("close_window")
	visible = false

func _on_background_music_slider_value_changed(value):
	_change_volume(value, "BackgroundMusic")
	

func _on_sound_effect_slider_value_changed(value):
	_change_volume(value, "SoundEffect")

func _change_volume(value, bus):
	var valueInDB : int
	
	if value == soundMinValue:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), false)
		
		valueInDB = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), valueInDB)	
		
	
	if bus == "BackgroundMusic": GameManager.backgroundMusicVolumen = valueInDB
	elif bus == "SoundEffect": GameManager.soundEffectsVolumen = valueInDB


func _on_texture_button_pressed():
	$AudioStreamPlayer2D.play()

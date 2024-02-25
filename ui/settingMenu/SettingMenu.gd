extends Control

@onready var soundEffectSlider = $"TextureRect/VBoxContainer/Sound Effects/SoundEffectSlider"
@onready var backgroundMusicSlider = $"TextureRect/VBoxContainer/Background Music/BackgroundMusicSlider"

var soundMinValue : int
var focusIsSet = false

signal close_window()

func _ready():
	backgroundMusicSlider.value = GameManager.backgroundMusicVolumen
	soundEffectSlider.value = GameManager.soundEffectsVolumen
	soundMinValue = soundEffectSlider.min_value

func _process(delta):
	if visible && !focusIsSet: 
		focusIsSet = true
		if !DisplayServer.is_touchscreen_available():
			$"TextureRect/VBoxContainer/Background Music/BackgroundMusicSlider".grab_focus()
	elif !visible: focusIsSet = false

func _on_close_button_pressed():
	Utils.save_game("settings")
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
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), value)	

	if bus == "BackgroundMusic": 
		GameManager.backgroundMusicVolumen = value if not value == backgroundMusicSlider.min_value else -25
	elif bus == "SoundEffect": 
		GameManager.soundEffectsVolumen = value if not value == soundEffectSlider.min_value else -25
	
func _on_texture_button_pressed():
	$AudioStreamPlayer2D.play()

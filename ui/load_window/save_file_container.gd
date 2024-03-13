extends PanelContainer

@export var gameNumber : int
@export var saveData : Dictionary
@export var loadingTexture : TextureRect
@export var playTimeLabel :Label
@export var gameDoneProcentLabel : Label

@onready var headerLabel = $VBoxContainer/Header/PanelContainer/HBoxContainer/LoadCount/PanelContainer/Label

signal deleteGame

var touchCanFire = true
var isLoaded = false


func _ready():
	if DisplayServer.is_touchscreen_available(): 
		focus_mode = Control.FOCUS_NONE

func _process(_delta):
	if has_focus():
		var styleBox : StyleBoxFlat = get_theme_stylebox("panel").duplicate()
		styleBox.border_color = Color(1,1,1)
		add_theme_stylebox_override("panel", styleBox)
	else:
		var styleBox : StyleBoxFlat = get_theme_stylebox("panel").duplicate()
		styleBox.border_color = Color(0.647, 0.671, 0.718)
		add_theme_stylebox_override("panel", styleBox)	
		
	headerLabel.text = str(gameNumber +1)
	
	if !isLoaded:
		isLoaded = true
		_set_procent_clear()
		_set_play_time()
		_set_load_file_image()

func _set_procent_clear():
	var allLevel : Array = saveData["levelDetails"]
	gameDoneProcentLabel.text = str(GameManager.procent_done(allLevel)) + " %"

func _set_play_time():
	var playTimeSeconds : int = saveData["playTimeSeconds"]
	playTimeLabel.text =  HelperFunctions.time_convert(playTimeSeconds)

func _set_load_file_image():  	
	var image = Image.load_from_file("user://screenshot"+ str(gameNumber) +".png")
	var texture = ImageTexture.create_from_image(image)
	loadingTexture.texture = texture  

func _start_game():
	if !touchCanFire: return
	
	GameManager.gameNumber = gameNumber
	GameManager.gameStart = Time.get_datetime_dict_from_system()
	Utils.load_game()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept") && has_focus():
		_start_game()

func _on_delete_button_pressed():
	$reallyDeleteContainer.visible = true
		
	touchCanFire = false
	$VBoxContainer.visible = false
	$MarginContainer/deleteButton.visible = false


func _on_start_game_touch_button_released():
	_start_game()


func _on_yes_button_pressed():
	Utils.delete_game(gameNumber)
	deleteGame.emit()
	queue_free()


func _on_no_button_pressed():
	$reallyDeleteContainer.visible = false
		
	touchCanFire = true
	$VBoxContainer.visible = true
	$MarginContainer/deleteButton.visible = true

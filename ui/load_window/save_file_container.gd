extends PanelContainer

@export var gameNumber : int
@export var saveData : Dictionary
@export var loadingTexture : TextureRect
@export var playTimeLabel :Label
@export var gameDoneProcentLabel : Label

var touchCanFire = true

func _process(_delta):
	print(has_focus())
	if has_focus():
		print()
		var styleBox : StyleBoxFlat = get_theme_stylebox("panel")
		styleBox.border_color = Color(1,0,0)
		add_theme_stylebox_override("panel", styleBox)
	$VBoxContainer/Header/PanelContainer/HBoxContainer/LoadCount/PanelContainer/Label.text = str(gameNumber +1)
	_set_procent_clear()
	_set_play_time()
	_set_load_file_image()

func _set_procent_clear():
	var allLevel : Array = saveData["levelDetails"]
	var levelDone = 0
	
	for level in allLevel:
		if level["isFinished"]: levelDone += 1
	
	var procentDone = levelDone * 100 / GameManager.LEVEL_COUNT
	gameDoneProcentLabel.text = str(procentDone) + " %"

func _set_play_time():
	var playTimeSeconds : int = saveData["playTimeSeconds"]
	playTimeLabel.text =  HelperFunctions.time_convert(playTimeSeconds)

func _set_load_file_image():  	
	var image = Image.load_from_file("user://screenshot"+ str(gameNumber) +".png")
	var texture = ImageTexture.create_from_image(image)
	loadingTexture.texture = texture  

func _on_delete_button_pressed():
	$reallyDeleteContainer.visible = true
		
	touchCanFire = false
	$VBoxContainer.visible = false
	$deleteButton.visible = false


func _on_start_game_touch_button_released():
	if !touchCanFire: return
	
	GameManager.gameNumber = gameNumber
	GameManager.gameStart = Time.get_datetime_dict_from_system()
	Utils.load_game()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")


func _on_yes_button_pressed():
	Utils.delete_game(gameNumber)
	queue_free()


func _on_no_button_pressed():
	$reallyDeleteContainer.visible = false
		
	touchCanFire = true
	$VBoxContainer.visible = true
	$deleteButton.visible = true

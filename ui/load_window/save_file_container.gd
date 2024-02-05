extends PanelContainer

@export var gameNumber = 0
@export var saveData : Dictionary
@export var loadingTexture : TextureRect
@export var playTimeLabel :Label
@export var gameDoneProcentLabel : Label


func _ready(): 
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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


func _on_start_game_touch_button_pressed():
	GameManager.gameNumber = gameNumber
	Utils.load_game()
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")


func _on_start_game_touch_button_released():
	Utils.delete_game(gameNumber)
	queue_free()

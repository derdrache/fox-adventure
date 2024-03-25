extends CanvasLayer

@onready var goldCoinLabel = $Control/FirstRow/MarginContainer/VBoxContainer/HBoxContainer2/GoldContainer/Label
@onready var levelUi = $Control/FirstRow/MarginContainer
@onready var settingMenu = $Control/SettingMenu
@onready var backgroundColor = $Control/ColorRect
@onready var menuContainer = $Control/MenuContainer
@onready var menuCloseIcon = $Control/FirstRow/MarginContainer2/MenuCloseIcon
@onready var menuButtonIcon = $Control/FirstRow/MarginContainer2/menuOpenIcon

func _ready():
	LevelManager.gained_gem.connect(update_gem_display)
	LevelManager.gained_red_coin.connect(update_red_coin_display)
	LevelManager.gained_gold_coin.connect(update_gold_coin_display)
	LevelManager.gained_cat.connect(update_cat_display)
	
	if !DisplayServer.is_touchscreen_available():
		$Control/FirstRow/MarginContainer2.visible = false

func _input(event):
	if event.is_action_pressed("open_menu"):
		if menuButtonIcon.visible: 
			get_tree().paused = true
			_on_menu_button_pressed()
			if !DisplayServer.is_touchscreen_available(): 
				$Control/MenuContainer/SettingButton.grab_focus()
		else: 
			if settingMenu.visible: _on_setting_menu_close_window()
			else: 
				get_tree().paused = false
				_on_menu_close_button_pressed()
			

func update_gem_display(gems):
	for i in range(gems):
		var path = "Control/FirstRow/MarginContainer/VBoxContainer/HBoxContainer/GemContainer/Gem" + str(i+1)
		var gemRect = get_node(path)
		gemRect.set_modulate(Color(1,1,1))

func update_red_coin_display(coins):
	for i in range(coins):
		var path = "Control/FirstRow/MarginContainer/VBoxContainer/HBoxContainer/RedCoinContainer/RedCoin" + str(i+1)
		var redCoinRect = get_node(path)
		redCoinRect.set_modulate(Color(1,1,1))
		
func update_cat_display(catArray):
	for i in len(catArray):
		if catArray[i]: 
			var path = "Control/FirstRow/MarginContainer/VBoxContainer/HBoxContainer/CatContainer/Cat" + str(i+1)
			var catRect = get_node(path)		
			catRect.set_modulate(Color(1,1,1))

func update_gold_coin_display(coins):
	goldCoinLabel.text = "x " + str(coins)


func _on_menu_button_pressed():
	menuContainer.visible = true
	menuCloseIcon.visible = true
	backgroundColor.visible = true
	
	menuButtonIcon.visible = false
	levelUi.visible = false
	

func _on_setting_menu_close_window():
	menuContainer.visible = true
	menuCloseIcon.visible = true
	
	settingMenu.visible = false
	$Control/MenuContainer/SettingButton.grab_focus()


func _on_exit_button_pressed():
	get_tree().paused = false
	LevelManager.reset_all_stats()
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")


func _on_setting_button_pressed():
	settingMenu.visible = true
	
	menuCloseIcon.visible = false
	menuContainer.visible = false


func _on_menu_close_button_pressed():
	menuContainer.visible = false
	menuCloseIcon.visible = false
	backgroundColor.visible = false
	
	menuButtonIcon.visible = true
	levelUi.visible = true

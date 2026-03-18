extends Node

var optMenu = null
var scoreBG := 0
#Used for jumpscare to get to last scene
var lastSceneOnJumpscare : String = "res://main_menu.tscn"
@onready var fade_animation_player = $CanvasBlackScreen/FadeAnimationPlayer

var optionsDict = {
	"VolMus" : 0.0,
	"VolSFX" : 0.0,
	"MouseSens" : .01,
	"FullScreen" : false,
	"WindowSize" : 1,
	#Same dictionary for other user data
	"otherData" : 9.99
	
}

signal optMouseSens

var save_path := "user://save_data.save"

func _ready() -> void:
	load_data()
	load_config()
	
	##Example on how to save other data
	#optionsDict.otherData = 0.0
	#save_data()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path,FileAccess.READ)
		optionsDict = file.get_var()
		print(optionsDict)

func save_data():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(optionsDict)

func load_config():
	loadVolMus(optionsDict.VolMus)
	loadVolSFX(optionsDict.VolSFX)
	loadWindowSize(optionsDict.WindowSize)
	loadMouseSens(optionsDict.MouseSens)
	loadFullscreen(optionsDict.FullScreen)

func loadVolMus(value):
	AudioServer.set_bus_volume_db(1,value)

func loadVolSFX(value):
	AudioServer.set_bus_volume_db(2,value)

func loadWindowSize(size : int):
	match size:
		0:
			DisplayServer.window_set_size(Vector2(800,600))
		1:
			DisplayServer.window_set_size(Vector2(1280,720))
		2:
			DisplayServer.window_set_size(Vector2(1920,1080))
		
	get_window().move_to_center()

func loadMouseSens(value):
	emit_signal("optMouseSens",value)

func loadFullscreen(isFullscreen : bool):
	match isFullscreen:
		true:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func fadeIn():
	fade_animation_player.play("fadeIn")

func fadeOut():
	fade_animation_player.play_backwards("fadeIn")

func changeScene(nextScene : String):
		fadeOut()
		await fade_animation_player.animation_finished
		get_tree().paused = false
		get_tree().call_deferred("change_scene_to_file",nextScene)
		fadeIn()

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		var isPlayer = get_tree().get_first_node_in_group("Player")
		#Different behaviour depending if there's a player or not in scene
		if ( isPlayer != null):
			if !optMenu:
				optMenu = preload("res://Menus/Options/options_screen.tscn").instantiate()
				isPlayer.add_child(optMenu)
			elif optMenu:
				optMenu._on_close_button_pressed()

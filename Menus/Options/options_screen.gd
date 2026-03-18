extends Panel

@onready var currentTab = $AudioTab

@onready var music_h_slider: HSlider = $AudioTab/HBoxContainer/MusicHSlider
@onready var sfxh_slider: HSlider = $AudioTab/HBoxContainer2/SFXHSlider
@onready var sensibility_h_slider: HSlider = $ControlsTab/HBoxContainer/SensibilityHSlider
@onready var resolution_button: OptionButton = $VideoTab/HBoxContainer/ResolutionButton
@onready var fullscreen_checkbox: CheckBox = $VideoTab/HBoxContainer2/FullscreenCheckbox
@onready var quit_game_panel: Window = $QuitGamePanel



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	if (get_parent().name == "Menu"):
		$ButtonsHBoxContainer/MenuButton.queue_free()
	
	
	fullscreen_checkbox.button_pressed = GlobalAutoloadBg.optionsDict.FullScreen
	resolution_button.selected = GlobalAutoloadBg.optionsDict.WindowSize
	sensibility_h_slider.value = GlobalAutoloadBg.optionsDict.MouseSens
	sfxh_slider.value = GlobalAutoloadBg.optionsDict.VolSFX
	music_h_slider.value = GlobalAutoloadBg.optionsDict.VolMus
	
func _on_close_button_pressed():
	if (get_tree().get_first_node_in_group("Player") != null):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	queue_free()

func _on_menu_button_pressed():
	GlobalAutoloadBg.changeScene("res://main_menu.tscn")



func _on_tab_bar_tab_changed(tab):
	currentTab.hide()
	match tab:
		0:
			currentTab = $AudioTab
		1:
			currentTab = $VideoTab
		2:
			currentTab = $ControlsTab
		_:
			currentTab = $AudioTab
	currentTab.show()


func _on_music_h_slider_value_changed(value: float) -> void:
	GlobalAutoloadBg.optionsDict.VolMus =  music_h_slider.value
	GlobalAutoloadBg.loadVolMus(music_h_slider.value)
	GlobalAutoloadBg.save_data()
	
func _on_sfxh_slider_value_changed(value: float) -> void:
	GlobalAutoloadBg.optionsDict.VolSFX = sfxh_slider.value
	GlobalAutoloadBg.loadVolSFX(sfxh_slider.value)
	GlobalAutoloadBg.save_data()
	
func _on_sensibility_h_slider_drag_ended(value_changed: bool) -> void:
	GlobalAutoloadBg.loadMouseSens(sensibility_h_slider.value)
	GlobalAutoloadBg.optionsDict.MouseSens = sensibility_h_slider.value
	GlobalAutoloadBg.save_data()

func _on_resolution_button_item_selected(index: int) -> void:
	GlobalAutoloadBg.optionsDict.WindowSize = index
	GlobalAutoloadBg.loadWindowSize(index)
	GlobalAutoloadBg.save_data()

func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	GlobalAutoloadBg.optionsDict.FullScreen = toggled_on
	GlobalAutoloadBg.loadFullscreen(toggled_on)
	GlobalAutoloadBg.save_data()


func _on_quit_button_pressed():
	quit_game_panel.popup_centered(Vector2i(400,200))


func _on_quit_game_panel_close_requested() -> void:
	quit_game_panel.hide()


func _on_q_yes_button_pressed() -> void:
	get_tree().quit()

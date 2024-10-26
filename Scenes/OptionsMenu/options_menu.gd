extends Control



func _on_WPM_changed(value:float) -> void:
	GlobalGameSettings.CPU_target_WPM = value
	


func _on_CPU_mode_selected(index: int) -> void:
	match index:
		0:
			GlobalGameSettings.cpu_cursor_mode = GlobalGameSettings.CPUPlayerMode.WPM
		1:
			GlobalGameSettings.cpu_cursor_mode = GlobalGameSettings.CPUPlayerMode.SongSync
		2:
			GlobalGameSettings.cpu_cursor_mode = GlobalGameSettings.CPUPlayerMode.Disabled
			
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_master_volume_drag_ended(value_changed: bool) -> void:
	GlobalGameSettings.master_volume = value_changed
	
func _on_music_volume_drag_ended(value_changed: bool) -> void:
	GlobalGameSettings.music_volume = value_changed

func _on_SFX_volume_drag_ended(value_changed: bool) -> void:
	GlobalGameSettings.sfx_volume = value_changed


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")

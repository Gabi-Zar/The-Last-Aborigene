@tool
class_name Config
extends Object

var ffmpeg_path: String = ""
var ffmpeg_var: bool = false

var parameters_name = "videoconverter"

var ffmpeg_path_name = parameters_name + "/ffmpeg_path"
var ffmpeg_var_name = parameters_name + "/ffmpeg_var"

func loadFile():
	var settings = EditorInterface.get_editor_settings()
	if settings.has_setting(ffmpeg_path_name):
		ffmpeg_path = settings.get_setting(ffmpeg_path_name)
	if settings.has_setting(ffmpeg_var_name):
		ffmpeg_var = settings.get_setting(ffmpeg_var_name)

func saveFile():
	var settings = EditorInterface.get_editor_settings()
	settings.set_setting(ffmpeg_path_name, ffmpeg_path)
	settings.set_setting(ffmpeg_var_name, ffmpeg_var)

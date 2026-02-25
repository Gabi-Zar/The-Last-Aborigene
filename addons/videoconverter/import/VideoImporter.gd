@tool
extends EditorImportPlugin

enum Presets { DEFAULT }

func _get_importer_name() -> String:
	return "godot.video.importer.videoconverter"

func _get_visible_name() -> String:
	return "Video Converter Importer"

func _get_recognized_extensions():
	return ["mp4", "avi", "mov", "mkv", "flv", "wmv"]

func _get_save_extension() -> String:
	return "ogv"

func _get_resource_type() -> String:
	return "VideoStreamTheora"

func _get_priority() -> float:
	return 1.0
	
func _get_preset_count() -> int:
	return Presets.size()

func _get_preset_name(preset_index: int) -> String:
	match preset_index:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"

func _get_import_options(path: String, preset_index: int) -> Array:
	match preset_index:
		Presets.DEFAULT:
			return [
				{
					"name": "video_bitrate",
					"default_value": 4000,
					"type": TYPE_INT,
					"hint": PROPERTY_HINT_RANGE,
					"hint_string": "100,12000,10",
					"usage": PROPERTY_USAGE_DEFAULT
				},
				{
					"name": "fps",
					"default_value": 24,
					"type": TYPE_INT,
					"hint": PROPERTY_HINT_RANGE,
					"hint_string": "1,60,1",
					"usage": PROPERTY_USAGE_DEFAULT
				},
				{
					"name": "gop_size",
					"default_value": 64,
					"type": TYPE_INT,
					"hint": PROPERTY_HINT_RANGE,
					"hint_string": "1,300,1",
					"usage": PROPERTY_USAGE_DEFAULT
				},
				{
					"name": "qv",
					"default_value": 6,
					"type": TYPE_INT,
					"hint": PROPERTY_HINT_RANGE,
					"hint_string": "1,10,1",
					"usage": PROPERTY_USAGE_DEFAULT
				}
			]
		_:
			return []

# documentation source https://docs.godotengine.org/fr/4.x/tutorials/animation/playing_videos.html#doc-playing-videos-recommended-theora-encoding-settings
func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array, gen_files: Array) -> int:
	var config: Config = Engine.get_singleton("config")
	
	var ffmpeg_path := "ffmpeg" if config.ffmpeg_var else config.ffmpeg_path
	if ffmpeg_path == "":
		push_error("The path is empty, please specify a valid path for using ffmpeg.")
		return ERR_CANT_CREATE
		
	var src := ProjectSettings.globalize_path(source_file)
	
	var out_rel := save_path + "." + _get_save_extension()
	var out_abs := ProjectSettings.globalize_path(out_rel)
	
	var temp_filename := "temp_" + str(Time.get_ticks_msec()) + "_" + out_rel.get_file()
	var out_temp_abs := out_abs.get_base_dir().path_join(temp_filename)
	
	var bitrate: int = int(options.get("video_bitrate", 4000) * 1000)
	var fps: int = int(options.get("fps", 24))
	var gop_size: int = int(options.get("gop_size", 64))
	var qv: int = int(options.get("qv", 6))

	var args := [
		"-y", "-i", src,
		"-b:v", str(bitrate),
		"-r", str(fps),
		"-q:v", str(qv),
		"-g:v", str(gop_size),
		out_temp_abs
	]
	
	var output := []
	var exit_code := OS.execute(ffmpeg_path, args, output, true)
	
	if exit_code != 0:
		push_error("Video conversion failed with exit code %d. Output:\n%s" % [exit_code, PackedStringArray(output)])
		if FileAccess.file_exists(out_temp_abs):
			DirAccess.remove_absolute(out_temp_abs)
		return ERR_CANT_CREATE

	if not FileAccess.file_exists(out_temp_abs):
		push_error("Video conversion failed: output file was not created.")
		return ERR_CANT_CREATE

	var dir = DirAccess.open(out_abs.get_base_dir())
	if dir:
		if FileAccess.file_exists(out_abs):
			var err = dir.remove(out_abs)
			if err != OK:
				push_error("LOCKING ERROR: Unable to replace the video file. It is probably being used by Godot. Deselect the video or close the scene using it.")
				dir.remove(out_temp_abs)
				return ERR_FILE_CANT_WRITE
		
		var rename_err = dir.rename(out_temp_abs, out_abs)
		if rename_err != OK:
			push_error("Error renaming temporary file.")
			return ERR_CANT_CREATE
	
	gen_files.append(out_rel)
	return OK

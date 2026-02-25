@tool
extends EditorPlugin

var video_converter
var dock
var config: Config

const AUTOLOAD_NAME = "ConfigAutoload"

func _enable_plugin() -> void:
	pass


func _disable_plugin() -> void:
	pass


func _enter_tree() -> void:
	config = Config.new()
	config.loadFile()
	Engine.register_singleton("config", config)
	
	video_converter = preload("import/VideoImporter.gd").new()
	add_import_plugin(video_converter)
	
	dock = preload("res://addons/videoconverter/config/config_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)

func _exit_tree() -> void:
	config.saveFile()
	Engine.unregister_singleton("config")
	remove_control_from_docks(dock)
	dock.free()

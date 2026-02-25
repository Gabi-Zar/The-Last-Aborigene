@tool
extends Control

# PATH
@export var fileButton: Button
@export var fileLine: LineEdit

# VAR
@export var varCheckbox: CheckBox

var fileDialog: EditorFileDialog
var config: Config = Engine.get_singleton("config")

func _ready() -> void:
	fileDialog = EditorFileDialog.new()
	add_child(fileDialog)

	fileDialog.set_file_mode(EditorFileDialog.FILE_MODE_OPEN_FILE)
	fileDialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	fileDialog.clear_filters()
	fileDialog.add_filter("*.exe", "EXE Files")
	fileDialog.file_selected.connect(_on_file_dialog_file_selected)
	
	fileLine.text = config.ffmpeg_path
	varCheckbox.button_pressed = config.ffmpeg_var

func _on_file_dialog_file_selected(path: String) -> void:
	fileLine.text = path
	config.ffmpeg_path = path

func _on_button_pressed() -> void:
	fileDialog.popup_centered()

func _on_check_box_toggled(toggled_on: bool) -> void:
	config.ffmpeg_var = toggled_on

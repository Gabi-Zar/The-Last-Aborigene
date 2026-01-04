extends Control

const ACTION_LIST = ["new_game"]

@onready var banner_label = $BannerTextureRect/BannerLabel
@onready var description_label = $DescriptionLabel

var current_action: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_yes_button_pressed() -> void:
	hide()
	if current_action == ACTION_LIST[0]: # new_game
		DirAccess.remove_absolute(Manager.SAVE_PATH + "save_game.dat")
		Manager.tree.change_scene_to_packed(Manager.packed_main_scene)


func _on_no_button_pressed() -> void:
	hide()

func call_pop_up(action) -> void:
	if (not action in ACTION_LIST) and (visible):
		print("no action called: " + action + "or pop up already visible")
		return
	
	current_action = action
	show()
	
	if action == ACTION_LIST[0]: # new_game
		banner_label.set_text("Create new game")
		description_label.set_text("creating a new game will delete all older save. \n\nAre you sure ?")

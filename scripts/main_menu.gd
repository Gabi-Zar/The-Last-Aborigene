extends Control

@onready var pop_up = $PopUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_new_game_button_pressed() -> void:
	pop_up.call_pop_up("new_game")


func _on_play_button_pressed() -> void:
	Manager.tree.change_scene_to_packed(Manager.packed_main_scene)


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	Manager.tree.quit()

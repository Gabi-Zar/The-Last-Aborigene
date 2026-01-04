extends CanvasLayer

@onready var pause_menu = $Control/PauseMenu
@onready var game_over_menu = $Control/GameOverMenu
@onready var game_over_menu_animation_player = $Control/GameOverMenu/AnimationPlayer
@onready var fade_in_out_animation_player = $Control/FadeInOut/AnimationPlayer

var game_over_menu_state = false

func _ready() -> void:
	fade_in_out_animation_player.play("fade_out")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and not Manager.player.is_dead:
		if not pause_menu.visible:
			pause_menu.show()
			Manager.player.can_move = false
		else:
			pause_menu.hide()
			Manager.player.can_move = true
	
	if Manager.player.is_dead and not game_over_menu_state:
		game_over_menu_state = true
		game_over_menu.show()
		game_over_menu_animation_player.play("game_over_menu_appear")


func _on_continue_button_pressed() -> void:
	pause_menu.hide()
	Manager.player.can_move = true

func _on_quit_button_pressed() -> void:
	Manager.save_game()
	Manager.tree.quit()

func _on_retry_button_pressed() -> void:
	Manager.tree.change_scene_to_packed(Manager.packed_main_scene)

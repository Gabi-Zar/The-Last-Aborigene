extends Node2D

@onready var area_2d = $Area2D
@onready var bench_label_animation = $Label/AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Manager.player in area_2d.get_overlapping_bodies():
		bench_label_animation.play("text_appear")
		if Input.is_action_just_pressed("Interact"):
			if Manager.player.can_move:
				Manager.last_bench_position = position
				Manager.save_game()
				
				Manager.player.position = position
				Manager.player.can_move = false
				Manager.player.z_index = -1
			else:
				Manager.player.can_move = true
				Manager.player.z_index = 2
	else:
		bench_label_animation.play("text_disappear")

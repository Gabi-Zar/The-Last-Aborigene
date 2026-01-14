extends "res://scripts/mob.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = 100
	speed = 100
	
	Manager.present_mob_list.append(self)


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	detect_player()
	avoid_void()
	if randi_range(0,200) == 0:
			jump()
	if current_mode == modes[0]:
		walk()
		avoid_walls()
		turn_sprite()
	
	if current_mode == modes[1]:
		if randi_range(0,20) == 0:
			follow_player()
		walk()
		avoid_void()
		if Manager.player.global_position.y <= global_position.y - 40:
			if randi_range(0,9) == 0:
				jump()
		
		if direction == 1:
			sprite.play("right_red_eye")
		elif direction == -1:
			sprite.play("left_red_eye")
	
	
	if not is_stopped:
		move_and_slide()

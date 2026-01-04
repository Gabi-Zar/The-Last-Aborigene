extends "res://scripts/mob.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = 100
	speed = 100
	
	Manager.present_mob_list.append(self)


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	walk()
	avoid_void()
	avoid_walls()
	if randi_range(0,200) == 0:
		jump()
	
	if not is_stopped:
		move_and_slide()

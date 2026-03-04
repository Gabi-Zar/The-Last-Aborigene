extends "res://scripts/mob.gd"

@onready var gun_particles = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = 300
	speed = 50
	damage = -1
	
	Manager.present_mob_list.append(self)


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	detect_player()
	avoid_void()
	turn_sprite()
	if randi_range(0,1000) == 0:
			jump()
	if current_mode == modes[0]:
		walk()
		avoid_walls()
	
	if current_mode == modes[1]:
		if randi_range(0,20) == 0:
			follow_player()
		walk()
		avoid_void()
		
		if randi_range(0,90) == 0:
			gun_particles.restart()
			if Manager.is_double_jump_unlocked:
				Manager.player.update_health(-1)
			else:
				Manager.player.update_health(0)
			Manager.player.velocity += position.direction_to(Manager.player.position) * 300 * Vector2(1, 3)
			Manager.player.move_and_slide()
		
		if direction == 1:
			gun_particles.position.x = -104
		elif direction == -1:
			gun_particles.position.x = 104
	
	
	if not is_stopped:
		move_and_slide()

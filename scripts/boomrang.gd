extends RigidBody2D

@onready var boomrang_area = $Area2D

var direction = 1
var return_timer = Timer.new()
var despawn_timer = Timer.new()
var strenght: int

func _ready() -> void:
	return_timer.wait_time = 0.2
	return_timer.one_shot = true
	add_child(return_timer)
	return_timer.start()
	
	despawn_timer.wait_time = 3.0
	despawn_timer.one_shot = true
	add_child(despawn_timer)
	despawn_timer.start()
	
	strenght = Manager.player.strenght

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if direction == 1:
		angular_velocity = deg_to_rad(-720)
	else:
		angular_velocity = deg_to_rad(720)
	
	if return_timer.is_stopped():
		apply_force(Vector2((Manager.player.global_position[0] - global_position[0]) * 6, (Manager.player.global_position[1] - global_position[1] - 100) * 6))
		for mob in Manager.present_mob_list:
			if mob in boomrang_area.get_overlapping_bodies():
				mob.take_damage(strenght)
		if boomrang_area.get_overlapping_bodies():
			Manager.player.boomrang_cooldown = false
			queue_free()
	
	if despawn_timer.is_stopped():
		Manager.player.boomrang_cooldown = false
		queue_free()

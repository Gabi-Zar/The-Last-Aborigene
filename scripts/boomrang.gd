extends RigidBody2D

@onready var boomrang_area = $Area2D

var player = Manager.player
var direction = 1
var return_timer = Timer.new()
var despawn_timer = Timer.new()

func _ready() -> void:
	return_timer.wait_time = 0.5
	return_timer.one_shot = true
	add_child(return_timer)
	return_timer.start()
	
	despawn_timer.wait_time = 3.0
	despawn_timer.one_shot = true
	add_child(despawn_timer)
	despawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction == 1:
		angular_velocity = deg_to_rad(-720)
	else:
		angular_velocity = deg_to_rad(720)
	
	if return_timer.is_stopped():
		apply_impulse(Vector2((player.global_position[0] - global_position[0]) * 0.2, (player.global_position[1] - global_position[1]) * 0.8))
		if player in boomrang_area.get_overlapping_bodies():
			queue_free()
	
	if despawn_timer.is_stopped():
		queue_free()

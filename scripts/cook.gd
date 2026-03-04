extends "res://scripts/mob.gd"

@onready var gun_particles = $GPUParticles2D
@export var roam_radius: float = 500.0
@export var move_interval: float = 3.0
@export var move_speed: float = 250.0

@export var use_area_rect: bool = true
@export var area_rect: Rect2 = Rect2(-200, -200, 400, 400)
@export var max_drop: float = 200.0 # maximum downward offset from start_pos

var _target_pos: Vector2
var _start_pos: Vector2
 
func _ready() -> void:
	# initialize mob defaults and register
	if hp <= 0:
		hp = 500
	print("Cook: _ready() name=", name, " global_position=", global_position, " hp=", hp)
	for child in get_children():
		if child is Node:
			var vis = ""
			if child is CanvasItem:
				vis = " visible=" + str(child.visible)
			print(" Cook child:", child.name, " ->", child, vis)
	Manager.present_mob_list.append(self)

	# react to death by switching to ending scene
	if has_signal("died"):
		connect("died", Callable(self, "_on_died"))

	# roaming setup
	randomize()
	_start_pos = global_position
	_target_pos = global_position
	var t = Timer.new()
	t.wait_time = move_interval
	t.one_shot = false
	add_child(t)
	t.start()
	t.connect("timeout", Callable(self, "_on_move_timer_timeout"))

func _on_move_timer_timeout() -> void:
	if use_area_rect:
		var rx = randf() * area_rect.size.x
		var ry = randf() * area_rect.size.y
		var local = area_rect.position + Vector2(rx, ry)
		_target_pos = _start_pos + local
	else:
		var angle = randf() * TAU
		var dist = randf() * roam_radius
		_target_pos = _start_pos + Vector2(cos(angle), sin(angle)) * dist
	# prevent choosing a target that is too far below the start position
	_target_pos.y = min(_target_pos.y, _start_pos.y + max_drop)
	print("Cook: new target=", _target_pos)

func _physics_process(delta: float) -> void:
	var to_target = _target_pos - global_position
	if to_target.length() > 8.0:
		var dir = to_target.normalized()
		velocity = dir * move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

	# clamp vertical position so cook cannot go too far down
	if global_position.y > _start_pos.y + max_drop:
		global_position.y = _start_pos.y + max_drop
		velocity.y = 0

func _on_died() -> void:
	print("Cook: died, switching to ending scene")
	get_tree().change_scene_to_file("res://scene/ending.tscn")

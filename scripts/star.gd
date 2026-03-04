extends CharacterBody2D

@export var speed: float = 500.0

var vel: Vector2 = Vector2.ZERO

const PLAYER_SCRIPT = preload("res://scripts/player.gd")
var can_damage := true
var damage_cooldown := 0.8
var damage_timer := Timer.new()

func _ready() -> void:
	randomize()
	vel = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed
	# damage timer
	damage_timer.wait_time = damage_cooldown
	damage_timer.one_shot = true
	add_child(damage_timer)
	damage_timer.connect("timeout", Callable(self, "_on_damage_timer_timeout"))
	# connect area signal
	var da = get_node_or_null("DamageArea")
	if da:
		da.connect("body_entered", Callable(self, "_on_damage_area_body_entered"))

func _physics_process(delta: float) -> void:
	# Move manually without gravity; bounce on collision normals
	var collision = move_and_collide(vel * delta)
	if collision:
		var n = collision.get_normal()
		vel = vel.bounce(n)
		# move slightly away from the surface to avoid sticking
		translate(n * 1.0)

func _on_damage_area_body_entered(body: Node) -> void:
	if body.get_script() == PLAYER_SCRIPT and can_damage:
		Manager.player.update_health(-1)
		can_damage = false
		damage_timer.start()

func _on_damage_timer_timeout() -> void:
	can_damage = true

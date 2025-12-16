extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -200.0
const JUMP_MAXIMUM_VELOCITY = -600.0
const DASH_VELOCITY = 2000

var latest_direction : float 
var dash_cooldown := Timer.new()
var double_jump_cooldown := false
var jump_limit = 0.0
var is_jumping := false

@onready var Sprite = $AnimatedSprite2D

func _ready() -> void:
	dash_cooldown.wait_time = 1
	dash_cooldown.one_shot = true
	add_child(dash_cooldown)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	############# Jump #############
	if is_on_floor():
		double_jump_cooldown = true
		if Input.is_action_pressed("Jump"):
			is_jumping = true
	
	if Input.is_action_just_released("Jump"):
		is_jumping = false
		jump_limit = 0.0
		if velocity.y < 0:
			velocity.y = move_toward(velocity.y,  0, JUMP_VELOCITY * -1)
		
	if Manager.is_double_jump_unlocked:
		if not is_jumping:
			if double_jump_cooldown:
				if not is_on_floor():
					if Input.is_action_pressed("Jump"):
						double_jump_cooldown = false
						is_jumping = true
	
	if is_jumping:
		if jump_limit > JUMP_MAXIMUM_VELOCITY:
			if velocity.y > 0.0:
				velocity.y = 0.0
			jump_limit += JUMP_VELOCITY
			velocity.y += JUMP_VELOCITY
	
	############# Movement #############
	var direction := Input.get_axis("Left", "Right")
	if direction:
		latest_direction = direction
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
		if direction == 1:
			Sprite.set_animation("right")
		else:
			Sprite.set_animation("left")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Manager.is_dash_unlocked:
		if Input.is_action_just_pressed("Dash"):
			if dash_cooldown.is_stopped():
				velocity.x += latest_direction * DASH_VELOCITY
				dash_cooldown.start()

	move_and_slide()

extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -200.0
const JUMP_MAXIMUM_VELOCITY = -600.0
const DASH_VELOCITY = 1500

var latest_direction : float 
var double_jump_cooldown := false
var jump_limit = 0.0
var is_jumping := false

var health := 5
var strenght := 20
var is_dead := false
var can_move := true

var dash_cooldown := Timer.new()
var damage_cooldown := Timer.new()
var boomrang_cooldown := false

@export var boomrang: PackedScene
var boomrang_instance: Node

@onready var sprite = $AnimatedSprite2D
@onready var boomrang_sprite = $BoomrangSprite2D
@onready var collision_area = $Area2D
@onready var animation_player = $AnimationPlayer
@onready var damage_audio_player = $DamageAudioStreamPlayer

func _ready() -> void:
	dash_cooldown.wait_time = 1
	dash_cooldown.one_shot = true
	add_child(dash_cooldown)
	
	damage_cooldown.wait_time = 0.4
	damage_cooldown.one_shot = true
	add_child(damage_cooldown)


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
	if direction and can_move:
		latest_direction = direction
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
		if direction == 1:
			sprite.play("right")
			boomrang_sprite.position.x = -51.0
			boomrang_sprite.rotation_degrees = 270.0
		else:
			sprite.play("left")
			boomrang_sprite.position.x = 51.0
			boomrang_sprite.rotation_degrees = 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Manager.is_dash_unlocked:
		if Input.is_action_just_pressed("Dash"):
			if dash_cooldown.is_stopped():
				velocity.x += latest_direction * DASH_VELOCITY
				dash_cooldown.start()
	
	if can_move:
		move_and_slide()
	
	############# Attaque #############
	if not boomrang_cooldown and can_move:
		boomrang_sprite.show()
		if Input.is_action_just_pressed("Attack"):
			boomrang_instance = boomrang.instantiate()
			boomrang_instance.position = position + boomrang_sprite.position
			boomrang_instance.rotation = boomrang_sprite.rotation
			if boomrang_instance.rotation == 0.0:
				boomrang_instance.direction = 1
				boomrang_instance.apply_impulse(Vector2(-1500, -50))
			else:
				boomrang_instance.direction = -1
				boomrang_instance.apply_impulse(Vector2(1500, -50))
			Manager.main.add_child(boomrang_instance)
			
			boomrang_sprite.hide()
			boomrang_cooldown = true
	
	############# Game over #############
	if health <= 0:
		is_dead = true
		can_move = false
		hide()
	
	############# Damage #############
	if not is_dead and damage_cooldown.is_stopped():
		for mob in Manager.present_mob_list:
			if mob in collision_area.get_overlapping_bodies():
				update_health(mob.damage)
				animation_player.play("damage")
				damage_audio_player.play()
				# SHAKE SCREEN TO DO
				damage_cooldown.start()


func update_health(life = 1):
	Manager.hud.get_node("HealthBar").value += life
	health += life

extends CharacterBody2D

var hp: int
var armor: int = 0
var damage: int = -1
var loot_table

var direction: int = 1
var is_stopped = false
var speed: int


@onready var floor_detector = $FloorRayCast2D
@onready var left_wall_detector = $LeftWallRayCast2D
@onready var right_wall_detector = $RightWallRayCast2D
@onready var direction_change_cooldown = $DirectionChangeCooldown
@onready var animation_player = $AnimationPlayer


func apply_gravity(delta, gravity = get_gravity()):
	if not is_on_floor():
		velocity += gravity * delta

func walk():
	if is_on_floor():
		velocity.x = speed * direction

func avoid_void():
	if not floor_detector.is_colliding() and direction_change_cooldown.is_stopped():
		direction *= -1
		direction_change_cooldown.start()

func avoid_walls():
	if left_wall_detector.get_collider() == Manager.terrain or right_wall_detector.get_collider() == Manager.terrain:
		if direction_change_cooldown.is_stopped():
			direction *= -1
			direction_change_cooldown.start()

func jump(jump_velocity = 300):
	if is_on_floor():
		velocity += Vector2(jump_velocity * direction * 0.2, -jump_velocity)
		direction_change_cooldown.start()

func take_damage(attack_strenght):
	var total_damage : int = attack_strenght - armor
	if total_damage > 0:
		hp -= total_damage
		animation_player.play("damage")
		if hp <= 0:
			Manager.present_mob_list.erase(self)
			queue_free()

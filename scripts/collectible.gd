extends RigidBody2D

@export var collectible_name: String

@onready var collectible_area = $GrabArea2D
@onready var collectible_floor_collision = $FloorCollisionShape2D
@onready var collectible_floor_detector = $FloorDetectorRayCast2D
@onready var collectible_sprite = $Sprite2D
@onready var collectible_sprite_animation = $Sprite2D/AnimationPlayer
@onready var collectible_label = $Label
@onready var collectible_label_animation = $Label/AnimationPlayer
@onready var collectible_particle = $CPUParticles2D

var death_timer := Timer.new()
var is_grabed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collectible_sprite_animation.play("collectible_animation")
	apply_impulse(Vector2(randf_range(-200,200), -500))
	
	death_timer.wait_time = 0.5
	death_timer.one_shot = true
	add_child(death_timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Manager.player in collectible_area.get_overlapping_bodies():
		collectible_label_animation.play("text_appear")
		if Input.is_action_just_pressed("Interact"):
			Manager.item_grabed(collectible_name)
			collectible_sprite.hide()
			is_grabed = true
			collectible_particle.restart()
			death_timer.start()
		if death_timer.is_stopped() and is_grabed == true:
			queue_free()
	else:
		collectible_label_animation.play("text_disappear")
	
	if collectible_floor_detector.get_collider() == Manager.terrain:
		collectible_floor_collision.disabled = false
		collectible_label.show()

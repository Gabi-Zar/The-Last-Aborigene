extends RigidBody2D

@export var collectible_name: String

@onready var collectible_area = $GrabArea2D
@onready var collectible_floor_collision = $FloorCollisionShape2D
@onready var collectible_floor_detector = $FloorDetectorRayCast2D
@onready var collectible_sprite_animation = $Sprite2D/AnimationPlayer
@onready var collectible_label = $Label
@onready var collectible_label_animation = $Label/AnimationPlayer
@onready var player = Manager.player
@onready var terrain = Manager.terrain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collectible_sprite_animation.play("collectible_animation")
	apply_impulse(Vector2(randf_range(-200,200), -500))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player in collectible_area.get_overlapping_bodies():
		collectible_label_animation.play("text_appear")
		if Input.is_action_just_pressed("Grab"):
			Manager.item_grabed(collectible_name)
			queue_free()
	else:
		collectible_label_animation.play("text_disappear")
	
	if collectible_floor_detector.get_collider() == terrain:
		collectible_floor_collision.disabled = false
		collectible_label.show()

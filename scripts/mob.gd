extends CharacterBody2D

var hp: int
var loot_table

var direction  = 1

@onready var floor_detector = $FloorRayCast2D
@onready var left_wall_detector = $LeftWallRayCast2D
@onready var right_wall_detector = $LeftWallRayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func avoid_void():
	if floor_detector.get_collider() == Manager.terrain:
		print("zob")
	

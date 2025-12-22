extends Node

@onready var root = Engine.get_main_loop().root
@onready var main = root.get_node("Main")
@onready var player = root.get_node("Main/Player")
@onready var terrain = root.get_node("Main/Terrain")

var is_dash_unlocked := false
var is_double_jump_unlocked := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func item_grabed(item_name):
	print(item_name + " picked up")
	if item_name == "dash":
		is_dash_unlocked = true
	elif item_name == "double_jump":
		is_double_jump_unlocked = true
	else:
		print("unknown item")

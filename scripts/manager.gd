extends Node

const SAVE_PATH = "user://Team Frank/The Last Aborigene/"

@export var packed_main_scene = preload("res://scene/main.tscn")

@onready var root = Engine.get_main_loop().root
@onready var tree = root.get_tree()
@onready var window = get_window()
var main : Node
var player : Node
var terrain : Node
var hud : Node
var cinematic : Node
var cinematic_camera : Node

var is_main_scene_loaded = false
var save_cooldown = 0.0

var is_dash_unlocked := false
var is_double_jump_unlocked := false
var last_bench_position := Vector2(2008.0, -96.0)
var present_mob_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window.exclude_from_capture = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if save_cooldown >= 60.0: #intervalle between save in seconds
		save_game()
		save_cooldown = 0.0
	else:
		save_cooldown += delta
	
	if Input.is_action_just_pressed("ToggleFullscreen"):
		if window.get_mode() == Window.MODE_FULLSCREEN:
			window.set_mode(Window.MODE_WINDOWED)
		else:
			window.set_mode(Window.MODE_FULLSCREEN)


func main_scene_loaded():
	main = root.get_node("Main")
	player = root.get_node("Main/Player")
	terrain = root.get_node("Main/Terrain")
	hud = root.get_node("Main/HUD/Control/HUD")
	cinematic = root.get_node("Main/Cinematic")
	cinematic_camera = root.get_node("Main/Cinematic/Camera2D")
	
	print(load_game())
	var save_data = load_game()
	if save_data:
		player.position = save_data[0]
		last_bench_position = save_data[0]
		is_dash_unlocked = save_data[1]
		is_double_jump_unlocked = save_data[2]
	else:
		cinematic_camera.make_current()
	
	is_main_scene_loaded = true

func save_game():
	if not is_main_scene_loaded:
		return
	
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_PATH)
	
	var file = FileAccess.open(SAVE_PATH + "save_game.dat", FileAccess.WRITE)
	file.store_double(last_bench_position.x)
	file.store_double(last_bench_position.y)
	file.store_8(is_dash_unlocked)
	file.store_8(is_double_jump_unlocked)
	print("game_saved")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH + "save_game.dat"):
		return
	var file = FileAccess.open(SAVE_PATH + "save_game.dat", FileAccess.READ)
	var position = Vector2(file.get_double(), file.get_double())
	var dash = file.get_8()
	var double_jump = file.get_8()
	return [position, dash, double_jump]

func item_grabed(item_name):
	print(item_name + " picked up")
	if item_name == "dash":
		is_dash_unlocked = true
	elif item_name == "double_jump":
		is_double_jump_unlocked = true
	else:
		print("unknown item")

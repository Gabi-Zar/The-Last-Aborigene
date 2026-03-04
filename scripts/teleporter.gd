extends Area2D

@export var required_flag_name := "is_double_jump_unlocked"
@export var destination_node_path: NodePath
@export var boss_music: AudioStream

const PLAYER_SCRIPT = preload("res://scripts/player.gd")

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	# Debug info to help verify the Area2D is configured
	var hitbox = get_node_or_null("Hitbox")
	print("Teleporter ready: monitoring=", monitoring, " layers=", collision_layer, " mask=", collision_mask)
	if hitbox:
		print("Hitbox shape set=", hitbox.shape != null)
	else:
		print("Hitbox node not found")

func _on_body_entered(body: Node) -> void:
	# Avoid relying on Manager.player reference (may not be set yet).
	# Detect the player by comparing its script instead.
	if body.get_script() != PLAYER_SCRIPT:
		return

	print("Teleporter: body entered - detected player")

	# Print whether the player has the double jump when colliding
	if Manager.is_double_jump_unlocked:
		print("with double jump")
	else:
		print("without double jump")

	var dest = get_node_or_null(destination_node_path)
	if dest == null:
		return

	# Support a few known Manager flags. If you need other flags, add them here.
	if required_flag_name == "is_double_jump_unlocked" and Manager.is_double_jump_unlocked:
		Manager.player.global_position = dest.global_position
		_post_teleport_actions()
		return
	if required_flag_name == "is_dash_unlocked" and Manager.is_dash_unlocked:
		Manager.player.global_position = dest.global_position
		_post_teleport_actions()
		return


	# If required_flag_name is empty, teleport unconditionally
	if required_flag_name == "":
		Manager.player.global_position = dest.global_position
		_post_teleport_actions()


func _post_teleport_actions() -> void:
	# Restore player HP to HUD max and switch to CameraBoss if present
	var hb = Manager.hud.get_node_or_null("HealthBar")
	if hb:
		hb.value = hb.max_value
		Manager.player.health = int(hb.max_value)

	var cam = null
	if Manager.main:
		cam = Manager.main.get_node_or_null("BossRoom/CameraBoss")
	else:
		cam = get_tree().get_root().get_node_or_null("Main/BossRoom/CameraBoss")
	if cam:
		cam.make_current()

	# Switch existing music player to boss music if provided
	if boss_music != null:
		var music_player = null
		if Manager.main:
			music_player = Manager.main.get_node_or_null("AudioStreamPlayer")
		else:
			music_player = get_tree().get_root().get_node_or_null("Main/AudioStreamPlayer")
		if music_player:
			music_player.stream = boss_music
			music_player.play()

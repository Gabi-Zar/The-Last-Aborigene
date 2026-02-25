extends Control  

@onready var diapo_index = 0
@onready var diapos = []

func _ready():
	diapos = [
		$TextureRect1,
		$TextureRect2,
		$TextureRect3,
		$TextureRect4,
		$TextureRect5,
		$TextureRect6,
		$TextureRect7,
		$TextureRect8,
		$TextureRect9,
		$TextureRect10,
		$TextureRect11,
		$TextureRect12
	]
	display_diapo()

func display_diapo():
	for i in range(diapos.size()):
		diapos[i].visible = (i == diapo_index)
		if diapos[i] is VideoStreamPlayer:
			diapos[i].play()
			diapos[i].set_stream_position(0)
	$LabelDiapo.text = "Diapo %d / %d" % [diapo_index + 1, diapos.size()]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Right") and diapo_index < diapos.size():
		diapo_index += 1
		display_diapo()
	elif Input.is_action_just_pressed("Left") and diapo_index > 0:
		diapo_index -= 1
		display_diapo()
	
	if diapo_index >= diapos.size():
		Manager.tree.change_scene_to_packed(Manager.packed_main_scene)

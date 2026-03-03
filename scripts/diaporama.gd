extends Control  

@onready var diapo_index = 0
@onready var diapos = []
var last_video

func _ready():
	diapos = [
		$TextureRect1,
		$TextureRect2,
		$Video3,
		$TextureRect4,
		$Video5,
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
		if diapo_index < diapos.size():
			if diapos[diapo_index] == $Video3 || diapos[diapo_index] == $Video5:
				last_video = diapos[diapo_index]
				diapos[diapo_index].play()
			else:
				if last_video:
					last_video.stop()
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

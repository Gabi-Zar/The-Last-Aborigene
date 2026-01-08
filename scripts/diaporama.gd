extends Control  

@onready var diapo_index = 0
@onready var diapos = []

const LEFT = 263   # left
const RIGHT = 262  # right

func _ready():
	diapos = [
		$TextureRect1,
		$TextureRect2,
		$TextureRect3,
		$TextureRect4,
		$TextureRect5
	]
	display_diapo()

func display_diapo():
	for i in range(diapos.size()):
		diapos[i].visible = (i == diapo_index)
	$LabelDiapo.text = "Diapo %d / %d" % [diapo_index + 1, diapos.size()]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Right") and diapo_index < diapos.size() - 1:
		diapo_index += 1
		display_diapo()
	elif Input.is_action_just_pressed("Left") and diapo_index > 0:
		diapo_index -= 1
		display_diapo()

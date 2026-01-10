extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Manager.player in get_overlapping_bodies():
		Manager.player.update_health(-100)

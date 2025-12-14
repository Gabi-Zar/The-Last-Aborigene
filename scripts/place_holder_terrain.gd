extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionPolygon2D.polygon = $Polygon2D.polygon

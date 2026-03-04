extends Node2D

@export var star_scene: PackedScene = preload("res://scene/star.tscn")
@export var count: int = 6
@export var area_rect: Rect2 = Rect2(-300, -200, 600, 400)

func _ready() -> void:
    randomize()
    for i in range(count):
        _spawn_star()

func _spawn_star() -> void:
    if star_scene == null:
        return
    var s = star_scene.instantiate()
    var pos = area_rect.position + Vector2(randf() * area_rect.size.x, randf() * area_rect.size.y)
    s.position = pos
    add_child(s)

extends Area2D


@onready var color_rect: ColorRect = $"../UI/Control/ColorRect"


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(color_rect, "modulate:a", 1.0, 0.8)
		await tween.finished
		call_deferred("_change_scene")

func _change_scene() -> void:
	get_tree().change_scene_to_file("res://node_2d2.tscn")

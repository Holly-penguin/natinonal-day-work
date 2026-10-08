extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		body.key_count += 1
		print("获得了钥匙，当前数量：", body.key_count)
		queue_free()

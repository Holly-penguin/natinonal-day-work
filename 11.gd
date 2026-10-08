extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_played:
		is_played = true
		
		if has_node("../../BGM"): # 去找以前的背景音乐
			$"../../BGM".stop()  # 让它闭嘴
			
		$AudioStreamPlayer.play() # 播放新音乐

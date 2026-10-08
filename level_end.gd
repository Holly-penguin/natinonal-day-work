extends Area2D

var is_finished: bool = false 
var is_played = false 

@onready var clear_image = $"../UI/Control/TextureRect"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if is_finished:
		return
	if body.is_in_group("player"):
		if body.key_count < 2:
			return 
		is_finished = true
		clear_image.visible = true 
		
		get_tree().paused = true
	if body.is_in_group("player") and not is_played:
		is_played = true
		if has_node("../../BGM"):
			$"../../AudioStreamPlayer".stop()  
			
		$"111".play() 

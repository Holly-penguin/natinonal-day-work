extends Area2D

# 导出变量，方便在编辑器里调参
@export var speed: float = 400.0
@export var damage: int = 1
@export var direction: int = 1 
@export var bullet_type: String = "enemy" 

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(self):
		queue_free()

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if not is_instance_valid(body):
		return
		
	if bullet_type == "enemy" and body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free() 
		return
	queue_free()

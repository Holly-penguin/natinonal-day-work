extends CharacterBody2D

@export var left_x: float = 100.0   
@export var right_x: float = 400.0  
@export var speed: float = 60.0    

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dir := 1
var health: int = 2 

func _ready() -> void:
	sprite.play("fly")

func _physics_process(delta: float) -> void:
	position.x += dir * speed * delta

	if position.x >= right_x:
		position.x = right_x
		dir = -1
		sprite.flip_h = true
	elif position.x <= left_x:
		position.x = left_x
		dir = 1
		sprite.flip_h = false

	var bodies = $AttackArea.get_overlapping_bodies()

	for body in bodies:
		if body == self:
			continue
		if body.has_method("take_damage"):
			body.take_damage(1)

	move_and_slide()


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		print(name, " 死亡!")
		queue_free() 

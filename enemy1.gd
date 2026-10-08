extends CharacterBody2D

#@export var left_boundary:float = 4800.0
#@export var right_boundary:float = 5100.0
@export var patrol_speed: float = 80.0 
@export var jump_velocity: float = -300.0 
var direction: int = 1                
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var health: int = 1

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		if not ray_cast_2d.is_colliding():
			direction *= -1
			ray_cast_2d.target_position.x *= -1

		velocity.x = direction * patrol_speed
		velocity.y = jump_velocity
	#if position.x <= left_boundary:
		#direction *= -1
	#if position.x >= right_boundary:
		#direction *= -1


	
	


	var bodies = $DamageArea2.get_overlapping_bodies()
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

extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const MAX_JUMPS = 2  
var jumps_left = MAX_JUMPS 

var health: int = 5
var is_attacking: bool = false
var can_take_damage: bool = true
var attack_hit_registered: bool = false
var facing_direction: int = 1  
var has_key: bool = false
var is_dead: bool = false
var key_count:int = 0 


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var health_label: Label = $"../UI/Control/HealthLabel"
func take_damage(amount: int) -> void:
	if is_dead or not can_take_damage:
		return
	health -= amount
	_update_health_ui()
	
	if health <= 0:
		health = 0
		_die() 
		return 
		
	can_take_damage = false
	await get_tree().create_timer(1.0).timeout
	can_take_damage = true

func _die() -> void:
	is_dead = true
	set_physics_process(false)
	await get_tree().create_timer(0.8).timeout
	call_deferred("_reload_scene")

func _reload_scene() -> void:
	get_tree().reload_current_scene()

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	animated_sprite_2d.play("idle")
	attack_area.monitoring = false
	_update_health_ui()


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if is_on_floor():
		jumps_left = MAX_JUMPS
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		attack_hit_registered = false
		animated_sprite_2d.play("attack")
		velocity.x = 0 
		
		if facing_direction > 0:
			animated_sprite_2d.flip_h = false
			attack_area.scale.x = 1 
		else:
			animated_sprite_2d.flip_h = true
			attack_area.scale.x = -1
			
		attack_area.monitoring = true

	if is_attacking:
		_check_attack_hit()
		move_and_slide()
		return

	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		if not is_on_floor() and jumps_left == 1:
			velocity.y = 0 
		
		velocity.y = JUMP_VELOCITY
		
		jumps_left -= 1
		
	if is_attacking:
		_check_attack_hit()
		move_and_slide()
		return

	var direction := Input.get_axis("ui_left", "ui_right")
	var current_speed = SPEED
	var has_dash_anim = animated_sprite_2d.sprite_frames.has_animation("dash")
	
	if Input.is_action_pressed("dash"):
		current_speed = DASH_SPEED
	
	if direction:
		facing_direction = direction
		
		velocity.x = direction * current_speed
		if direction > 0:
			animated_sprite_2d.flip_h = false
			attack_area.scale.x = 1
		else:
			animated_sprite_2d.flip_h = true
			attack_area.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor():
		if direction != 0:
			if Input.is_action_pressed("dash") and has_dash_anim:
				animated_sprite_2d.play("dash")
			else:
				animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()


func _check_attack_hit() -> void:
	if attack_hit_registered:
		return
		
	var hit_enemies = attack_area.get_overlapping_bodies()
	for enemy in hit_enemies:
		if enemy.is_in_group("enemies"):
			enemy.take_damage(1)
			attack_hit_registered = true
			
			
func _update_health_ui() -> void:
	if health_label:
		health_label.text = "血量: " + str(health)


func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack":
		is_attacking = false
		attack_area.monitoring = false
		if Input.get_axis("ui_left", "ui_right") != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")


func _on_attack_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

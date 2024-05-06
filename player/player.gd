extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var parry_sound = $ParrySound
@onready var player = $"."
@onready var attack_timer = $AttackTimer

var parry_effect = preload("res://effects/parry_effect.tscn")
var _death_text = preload("res://textures/died_text.png")

@export var player_health : int

const GRAVITY = 2000
const SPEED = 1000
@export var max_horizontal_speed: int = 300
@export var slow_down_speed : int = 10000
@onready var hitbox = $Hitbox/hitboxCollision
@onready var parrybox = $Parrybox/parryCollision
@onready var hurtbox = $Hurtbox/hurtboxCollision
const jump_speed = -430
const jump_horizontal_speed = 1000
@export var max_jump_horizontal_speed: int = 300

const player_max_health = 100
const roll_speed = 1.05
const roll_duration = 0.3
const roll_cooldown = 0.1

var can_roll = true
var can_parry = true
var parried = false
var is_dead = false
var healing_on_cooldown = false
var stagger_direction : int
enum State {Idle, Run, Roll, Jump, Attack, aerialAttack, Falling, Parry, Staggered, Healing, Stopped}
var current_state
func _ready(): #create event
	current_state = State.Idle

func _physics_process(delta): #step event (60 fps)
	var direction = Input.get_axis("move_left", "move_right")
	_is_dead()
	if !is_dead and current_state != State.Stopped:
		if  current_state != State.Parry and current_state != State.Attack and current_state != State.Roll and current_state != State.Staggered :
		
			player_falling(delta)
			player_idle(delta)
			player_run(delta)
		
			heal()
			player_attack(delta)
			player_parry(delta)
			move_and_slide()
		if current_state == State.Roll:
			player_roll(delta, direction)
			move_and_slide()
		
		if current_state == State.aerialAttack:
			player_falling(delta)
			move_and_slide()
		
		if Input.is_action_just_pressed("jump"):
			#print("jumped")
			player_jump(delta)
			move_and_slide()
	
		if Input.is_action_just_pressed("roll") and can_roll and direction !=0:
			#print("roll pressed")
			current_state = State.Roll
			can_roll = false;
			await(get_tree().create_timer(roll_duration).timeout)
			current_state = State.Idle
			can_roll = true
		
		player_animations()
	
	
func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(delta):
	if is_on_floor():
		current_state = State.Idle

func player_run(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x += direction * SPEED * delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)
		
	if direction != 0:
		current_state = State.Run
		#print("running")
		animated_sprite_2d.flip_h = false if  direction > 0 else true
		if animated_sprite_2d.flip_h == true:
			hitbox.position.x = -21
			parrybox.position.x = -13
		else:
			hitbox.position.x = 21
			parrybox.position.x = 13
			
func player_jump(delta):
	if is_on_floor():
		velocity.y += jump_speed
		current_state = State.Jump
	
	if !is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)

func player_attack(delta):
	if is_on_floor() and Input.is_action_just_pressed("attack"):
		current_state = State.Attack
		animated_sprite_2d.play("Attack2")
		attack_timer.start()
		
		can_roll = false
		
		await(animated_sprite_2d.animation_finished)  
		await(get_tree().create_timer(0.2).timeout)
		
		current_state = State.Idle  
		if current_state != State.Roll:
			can_roll = true
		

func player_roll(delta, direction):
	#AddCollisionExceptionWith()
	velocity.x = move_toward(velocity.x, velocity.x+500*direction, delta) * roll_speed
	#print(velocity.x)
	#print("rolled")

func player_parry(delta: float):
	if Input.is_action_just_pressed("parry") and is_on_floor() and can_parry:
		current_state = State.Parry
		can_parry = false
		parrybox.disabled = false
		animated_sprite_2d.play("Parry")
		await(get_tree().create_timer(0.4).timeout)
		parrybox.disabled = true
		
		
		current_state = State.Idle
		await(get_tree().create_timer(0.3).timeout)
		can_parry = true
		
func _is_dead():
	if HealthManager.current_health == 0 and !is_dead:
		is_dead = true
		hurtbox.disabled = true
		animated_sprite_2d.play("Death")
		await(animated_sprite_2d.animation_finished)
		await(get_tree().create_timer(4).timeout)
		GameController.player_died.emit(player)
		
		
func player_animations(): 
	if current_state == State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run and is_on_floor():
		animated_sprite_2d.play("Run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("Jump")
	elif current_state == State.Roll:
		animated_sprite_2d.play("Dash")


func _on_hitbox_area_entered(area : Area2D):
	#print("Hit")
	var parent = area.get_parent()
	#print(parent)
	if area.has_node("hurtboxCollision"):
		parent.health_Points -= GameController.current_damage
		print(parent.health_Points)
		
	#elif area.has_node("HurtboxCollision"):
		#parent.current_health -= GameController.current_damage
		

func _on_hitbox_body_entered(body):
	#print("Body entered")
	pass


func _on_parrybox_area_entered(area : Area2D):
	
	if area.has_node("hitboxCollision") or area.name.find("Hitbox") != -1:
		can_parry = true
		parried = true
		_parry_effect()
		parry_sound.play()
		await(get_tree().create_timer(0.45).timeout)
		parried = false
		

func _on_hurtbox_area_entered(area : Area2D):
	#area.name.find("Hitbox") != -1
	if area.has_node("hitboxCollision") or area.name.find("Hitbox") != -1 and parried == false:
		
		HealthManager.decrease_health(area.get_parent().damage_amount)
		
		print(HealthManager.current_health)
		
		var parent = area.get_parent()
		var enemy_sprite : AnimatedSprite2D = parent.get_node("AnimatedSprite2D")
		
		if enemy_sprite.flip_h == true:
			stagger_direction = -1
		else:
			stagger_direction = 1
		
		current_state = State.Staggered
		animated_sprite_2d.play("Stagger")
		velocity.x = 100 * stagger_direction
		move_and_slide()
		
		await(get_tree().create_timer(0.4).timeout)
		current_state = State.Idle

func _parry_effect():
	var parry_effect_instance = parry_effect.instantiate() as Node2D
	parry_effect_instance.global_position = parrybox.global_position
	get_parent().add_child(parry_effect_instance)
	#print(parry_effect_instance.global_position)
	#queue_free()

func death_text():
	var death_text_instance = _death_text.instantiate() as Node2D
	var viewport_size = get_viewport_rect().size
	death_text_instance.global_position = viewport_size / 2
	get_parent().add_child(death_text_instance)

func restart_game():
	var current_scene = get_tree().get_current_scene()
	get_tree().reload_current_scene()

func heal():
	
	if Input.is_action_just_pressed("heal") and HealthManager.current_potion_number > 0 and !healing_on_cooldown :
		healing_on_cooldown = true
		HealthManager.current_potion_number -= 1
		HealthManager.increase_health(HealthManager.max_health/3)
		
		await(get_tree().create_timer(1).timeout)
		healing_on_cooldown = false



func _on_attack_timer_timeout():
	hitbox.disabled = false
	await(get_tree().create_timer(0.2).timeout)
	hitbox.disabled = true

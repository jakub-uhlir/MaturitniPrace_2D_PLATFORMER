extends CharacterBody2D

@export var health_Points : int
@export var patrol_points : Node
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var wizard_enemy = $"."
@onready var attack_timer = $attackTimer
@export var damage_amount : int = 30
@export var souls_dropped : int
var max_health : int 
@onready var initial_position_marker 
var initial_position : Vector2

var random = RandomNumberGenerator.new()
var attack_randomizer : int

var parent 
var is_attacking = false
var on_cooldown = false

const GRAVITY = 1000
const SPEED = 1500

enum State {Idle, Run, Attack, Stopped}
var current_state : State

var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int

@onready var detect_area = $DetectArea/detectCollision
@onready var hitbox = $Hitbox/hitboxCollision
@onready var aggro_area = $AggroArea/aggroCollision
@onready var aggroArea = $AggroArea

var is_dead = false
func _ready():
	max_health = health_Points
	current_state = State.Idle
	patrol_points = get_node("patrolPoints")
	initial_position = wizard_enemy.global_position
	
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
			print("No patrol points.")
			
func _physics_process(delta: float):
	
	_is_dead(delta)
	
	if !is_dead and current_state == State.Attack and current_state != State.Stopped:
		enemy_attack(delta)
		#print(is_attacking)
	if is_dead == false and current_state != State.Attack and current_state != State.Stopped :
		
		enemy_gravity(delta)
		enemy_idle(delta)
		enemy_walk(delta)
	
		move_and_slide()
		enemy_animations()
	
func enemy_gravity(delta: float):
	velocity.y += GRAVITY * delta


func enemy_idle(delta: float):
	velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	current_state = State.Idle

func enemy_walk(delta: float):
	if abs(position.x -current_point.x) > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = State.Run
	else:
		current_point_position += 1
	
	if current_point_position >= number_of_points:
		current_point_position = 0
	
	current_point = point_positions[current_point_position]
	
	if current_point.x > position.x:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	
	animated_sprite_2d.flip_h = direction.x < 0 * -1
	if animated_sprite_2d.flip_h == true:
		hitbox.position.x = -20
		detect_area.position.x = -83.5
	else:
		hitbox.position.x = 20
		detect_area.position.x = 83.5
		
func enemy_attack(delta : float):
	
	if abs(position.x - parent.position.x) > 60 and !is_attacking:
		
		
		
		if position.x > parent.position.x:
			direction.x = -1
		else:
			direction.x = 1
			
		animated_sprite_2d.flip_h = direction.x < 0 * -1
		animated_sprite_2d.play("Run")
		velocity.x = direction.x * 3000 * delta
		if animated_sprite_2d.flip_h == true:
			hitbox.position.x = -66.5
		else:
			hitbox.position.x = 66.5
			
		hitbox.disabled = true
		move_and_slide()
		
	if !on_cooldown and is_attacking == false and abs(position.x - parent.position.x) < 60:
		
		attack_randomizer = random.randi_range(1,2)
		print(attack_randomizer)
		
		if attack_randomizer == 1:
			animated_sprite_2d.play("Attack")
			on_cooldown = true
			is_attacking = true
			attack_timer.wait_time = 0.4
			attack_timer.start()
			print("timer started")
		
			await(get_tree().create_timer(0.7).timeout)
		
			hitbox.disabled = true
		
			await(get_tree().create_timer(0.5).timeout)
		
			if abs(position.x - parent.position.x) < 60:
				animated_sprite_2d.play("Attack2")
		
				is_attacking = true
				attack_timer.wait_time = 0.45
				attack_timer.start()
				await(get_tree().create_timer(0.7).timeout)
				hitbox.disabled = true
				await(get_tree().create_timer(0.9).timeout)
				is_attacking = false
				on_cooldown = false
			
			else:
				is_attacking = false
				on_cooldown = false
				
		elif attack_randomizer == 2:
			
			animated_sprite_2d.play("Attack")
			on_cooldown = true
			is_attacking = true
			attack_timer.wait_time = 0.4
			attack_timer.start()
			print("timer started")
		
			await(get_tree().create_timer(0.7).timeout)
		
			hitbox.disabled = true
		
			await(get_tree().create_timer(0.2).timeout)
			
			animated_sprite_2d.play("Attack2")
		
			is_attacking = true
			attack_timer.wait_time = 0.45
			attack_timer.start()
			await(get_tree().create_timer(0.7).timeout)
			hitbox.disabled = true
			await(get_tree().create_timer(0.2).timeout)
			is_attacking = false
			on_cooldown = false
			
			animated_sprite_2d.play("Attack")
			on_cooldown = true
			is_attacking = true
			attack_timer.wait_time = 0.4
			attack_timer.start()
			print("timer started")
		
			await(get_tree().create_timer(0.7).timeout)
		
			hitbox.disabled = true
		
			await(get_tree().create_timer(0.2).timeout)
			
			animated_sprite_2d.play("Attack2")
		
			is_attacking = true
			attack_timer.wait_time = 0.45
			attack_timer.start()
			await(get_tree().create_timer(0.7).timeout)
			hitbox.disabled = true
			await(get_tree().create_timer(0.2).timeout)
			is_attacking = false
			on_cooldown = false
			
			animated_sprite_2d.play("Attack")
			on_cooldown = true
			is_attacking = true
			attack_timer.wait_time = 0.4
			attack_timer.start()
			print("timer started")
		
			await(get_tree().create_timer(0.7).timeout)
		
			hitbox.disabled = true
		
			await(get_tree().create_timer(0.2).timeout)
			
			animated_sprite_2d.play("Attack2")
		
			is_attacking = true
			attack_timer.wait_time = 0.45
			attack_timer.start()
			await(get_tree().create_timer(0.7).timeout)
			hitbox.disabled = true
			await(get_tree().create_timer(0.9).timeout)
			is_attacking = false
			on_cooldown = false
			
func enemy_animations():
	
	if current_state == State.Run:
		animated_sprite_2d.play("Run")


func _on_hurtbox_area_entered(area : Area2D):
	
	print("Got hit")
	parent = area.get_parent()
	current_state = State.Attack
	print(wizard_enemy)

func _is_dead(delta: float):
	
	if health_Points < 0 and !is_dead:
		GameController.souls_counter_changed.emit(souls_dropped)
		is_dead = true
		animated_sprite_2d.play("Death")
		await(animated_sprite_2d.animation_finished)
		if wizard_enemy:
			wizard_enemy.visible = false
			aggroArea.monitoring = false
			for child in wizard_enemy.get_children():
				if child is CollisionShape2D:
					child.disabled = true

func _on_detect_area_area_entered(area):
		print("player detected")
		print(area)
		if area.has_node("hurtboxCollision"):
			#parent = area.get_parent()
			aggroArea.monitoring = true
			detect_area.disabled = true
			#current_state = State.Attack


func _on_aggro_area_area_entered(area):
	if area.has_node("hurtboxCollision"):
		print("player entered")
		parent = area.get_parent()
		current_state = State.Attack


func _on_aggro_area_area_exited(area):
	print("exited")
	print(area)
	if area.has_node("hurtboxCollision"):
		aggroArea.monitoring = false
		detect_area.disabled = false
		current_state = State.Idle



func _on_attack_timer_timeout():
	print("timeout")
	hitbox.disabled = false
	





extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
const GRAVITY = 2000
const SPEED = 1000
@export var max_horizontal_speed: int = 300
@export var slow_down_speed : int = 10000

const jump_speed = -430
const jump_horizontal_speed = 1000
@export var max_jump_horizontal_speed: int = 300

const roll_speed = 1.05
const roll_duration = 0.3
const roll_cooldown = 0.1
var can_roll = true

enum State {Idle, Run, Roll, Jump, Attack, aerialAttack, Falling}
var current_state
func _ready(): #create event
	current_state = State.Idle

func _physics_process(delta): #step event (60 fps)
	var direction = Input.get_axis("move_left", "move_right")
	if current_state != State.Attack and current_state != State.Roll:
		
		player_falling(delta)
		player_idle(delta)
		player_run(delta)
		
		player_attack(delta)
		move_and_slide()
	if current_state == State.Roll:
		player_roll(delta, direction)
		move_and_slide()
		
	if current_state == State.aerialAttack:
		player_falling(delta)
		move_and_slide()
		
	if Input.is_action_just_pressed("jump"):
		print("jumped")
		player_jump(delta)
		move_and_slide()
	
	if Input.is_action_just_pressed("roll") and can_roll and direction !=0:
		print("roll pressed")
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
		print("running")
		animated_sprite_2d.flip_h = false if  direction > 0 else true

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
		can_roll = false
		animated_sprite_2d.play("Attack")  
		await(animated_sprite_2d.animation_finished)  
		await(get_tree().create_timer(0.2).timeout)
		current_state = State.Idle  
		if current_state != State.Roll:
			can_roll = true
		
	if !is_on_floor() and Input.is_action_just_pressed("attack"):
		current_state = State.aerialAttack
		animated_sprite_2d.play("airAttack")
		await(animated_sprite_2d.animation_finished)
		current_state = State.Falling
		

func player_roll(delta, direction):
	#AddCollisionExceptionWith()
	velocity.x = move_toward(velocity.x, velocity.x+500*direction, delta) * roll_speed
	print(velocity.x)
	print("rolled")
	
func player_animations(): 
	if current_state == State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run and is_on_floor():
		animated_sprite_2d.play("Run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("Jump")
	elif current_state == State.Roll:
		animated_sprite_2d.play("Dash")

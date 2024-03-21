extends CharacterBody2D

@export var patrol_points : Node
@onready var animated_sprite_2d = $AnimatedSprite2D

const GRAVITY = 1000
const SPEED = 1500

enum State {Idle, Run}
var current_state : State

var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int

func _ready():
	current_state = State.Idle
	
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
			print("No patrol points.")
			
func _physics_process(delta: float):
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
	
	animated_sprite_2d.flip_h = direction.x < 0
	
func enemy_animations():
	if current_state == State.Run:
		animated_sprite_2d.play("Run")

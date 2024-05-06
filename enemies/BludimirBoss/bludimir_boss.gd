extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var boss_body = $"."
@onready var hitbox_timer = $HitboxTimer
@onready var combo_timer = $ComboTimer



#RANDOM VARIABLES -->
var random = RandomNumberGenerator.new()
var attack_randomizer : int


var player_character : CharacterBody2D

#ATTACK HITBOXES -->
@onready var hitbox1_collision = $Hitbox1/Hitbox1Collision
@onready var hitbox2_collision = $Hitbox2/Hitbox2Collision
@onready var hitbox3_collision = $Hitbox3/Hitbox3Collision
@onready var sphitbox_collision = $SpHitbox/SpHitboxCollision
var hitbox_number : int

var direction : Vector2
const speed = 700

#STATE TRANSITION VARIABLES -->
enum State {Attacking, Idle}
var current_state

#HEALTH VARIABLES -->
var max_health = 500
var current_health : float

#COMBAT VARIABLES -->
var is_attacking = false
var on_cooldown = false
var damage_amount : int

func _ready():
	
	current_health = max_health
	player_character = get_tree().root.get_node("boss_test").get_node("player")
	current_state = State.Attacking

func _physics_process(delta):
	
	if current_state == State.Attacking:
		attack(delta)
	
	if current_state == State.Idle:
		
		animated_sprite_2d.play("Idle")


func walk():
	pass


func attack(delta : float):
	
	if abs(position.x - player_character.position.x) > 60 and !is_attacking:
		if position.x > player_character.position.x:
			direction.x = -1
		else:
			direction.x = 1
			
		animated_sprite_2d.flip_h = direction.x < 0 * -1
		animated_sprite_2d.play("Run")
		velocity.x = direction.x * 3000 * delta
		
		hitbox_direction_flip()
		hitbox_disable()
		
		
		move_and_slide()
	
	if abs(position.x - player_character.position.x) < 60 and !is_attacking and !on_cooldown:
		#attack_randomizer = 5
		attack_randomizer = random.randi_range(1,5)
		#print(attack_randomizer)
		if attack_randomizer == 1:
			attack_combination_one()
		elif attack_randomizer == 2:
			attack_combination_two()
		elif attack_randomizer == 3:
			attack_combination_three()
		elif attack_randomizer == 4:
			attack_combination_four()
		elif attack_randomizer == 5:
			attack_combination_five()




func hitbox_disable():
	hitbox1_collision.disabled = true
	hitbox2_collision.disabled = true
	hitbox3_collision.disabled = true
	sphitbox_collision.disabled = true
	
func hitbox_direction_flip():
	
	if animated_sprite_2d.flip_h == true:
			hitbox1_collision.position.x = -39.5
			hitbox2_collision.position.x = -1.5
			hitbox3_collision.position.x = -54
			sphitbox_collision.position.x = -61
	else:
			hitbox1_collision.position.x = 39.5
			hitbox2_collision.position.x = 1.5
			hitbox3_collision.position.x = 54
			sphitbox_collision.position.x = 61

func attack_combination_one():
	
	animated_sprite_2d.play("Attack1")
	damage_amount = 40
	is_attacking = true
	on_cooldown = true
	hitbox_number = 1
	hitbox_timer.wait_time = 0.45
	hitbox_timer.start()
	
	await(get_tree().create_timer(0.7).timeout)
	hitbox1_collision.disabled = true
	await(get_tree().create_timer(0.4).timeout)
	
	if abs(position.x - player_character.position.x) < 60:
		
		animated_sprite_2d.play("Attack2")
		damage_amount = 30
		is_attacking = true
		hitbox_number = 2
		hitbox_timer.wait_time = 0.35
		hitbox_timer.start()
		
		await(get_tree().create_timer(0.7).timeout)
		hitbox2_collision.disabled = true
		await(get_tree().create_timer(0.5).timeout)
		
		if abs(position.x - player_character.position.x) < 60:
			
			animated_sprite_2d.play("Attack3")
			damage_amount = 50
			is_attacking = true
			hitbox_number = 3
			hitbox_timer.wait_time = 0.5
			hitbox_timer.start()
			
			await(get_tree().create_timer(0.7).timeout)
			hitbox3_collision.disabled = true
			await(get_tree().create_timer(1.2).timeout)
			
			is_attacking = false
			on_cooldown = false
		else:
			
			is_attacking = false
			on_cooldown = false
	else:
		is_attacking = false
		on_cooldown = false
	
	
	
func attack_combination_two():
	
	animated_sprite_2d.play("Attack1")
	print("Combo: 2, Step: 1")
	damage_amount = 40
	is_attacking = true
	on_cooldown = true
	hitbox_number = 1
	hitbox_timer.wait_time = 0.45
	hitbox_timer.start()
	
	await(get_tree().create_timer(0.7).timeout)
	hitbox1_collision.disabled = true
	await(get_tree().create_timer(0.45).timeout)
	
	if abs(position.x - player_character.position.x) < 60:
		animated_sprite_2d.stop()
		animated_sprite_2d.play("Attack2")
		print("Combo: 2, Step: 2")
		damage_amount = 30
		is_attacking = true
		hitbox_number = 2
		hitbox_timer.wait_time = 0.35
		hitbox_timer.start()
		
		await(get_tree().create_timer(0.7).timeout)
		hitbox2_collision.disabled = true
		await(get_tree().create_timer(0.3).timeout)
		
		if abs(position.x - player_character.position.x) < 60:
			animated_sprite_2d.stop()
			animated_sprite_2d.play("Attack2")
			print("Combo: 2, Step: 3")
			damage_amount = 30
			is_attacking = true
			hitbox_number = 2
			hitbox_timer.wait_time = 0.35
			hitbox_timer.start()
			
			await(get_tree().create_timer(0.7).timeout)
			hitbox2_collision.disabled = true
			await(get_tree().create_timer(0.3).timeout)
			
			if abs(position.x - player_character.position.x) < 60:
				animated_sprite_2d.stop()
				animated_sprite_2d.play("Attack2")
				print("Combo: 2, Step: 4")
				damage_amount = 30
				is_attacking = true
				hitbox_number = 2
				hitbox_timer.wait_time = 0.35
				hitbox_timer.start()
				
				await(get_tree().create_timer(0.7).timeout)
				hitbox2_collision.disabled = true
				await(get_tree().create_timer(1.2).timeout)
				
				is_attacking = false
				on_cooldown = false
				
			else:
				is_attacking = false
				on_cooldown = false
		else:
			is_attacking = false
			on_cooldown = false
	else:
		is_attacking = false
		on_cooldown = false
	
func attack_combination_three():
	#STEP 1 
	animated_sprite_2d.play("Attack1")
	print("Combo: 3, Step: 1")
	damage_amount = 40
	is_attacking = true
	on_cooldown = true
	hitbox_number = 1
	hitbox_timer.wait_time = 0.45
	hitbox_timer.start()
	
	await(get_tree().create_timer(0.7).timeout)
	hitbox1_collision.disabled = true
	await(get_tree().create_timer(0.45).timeout)
	
	#STEP 2 
	if abs(position.x - player_character.position.x) < 60:
		animated_sprite_2d.stop()
		animated_sprite_2d.play("Attack2")
		print("Combo: 3, Step: 2")
		damage_amount = 30
		is_attacking = true
		hitbox_number = 2
		hitbox_timer.wait_time = 0.35
		hitbox_timer.start()
		
		await(get_tree().create_timer(0.7).timeout)
		hitbox2_collision.disabled = true
		await(get_tree().create_timer(0.3).timeout)
		
		#STEP 3
		if abs(position.x - player_character.position.x) < 60:
			animated_sprite_2d.stop()
			animated_sprite_2d.play("Attack2")
			print("Combo: 3, Step: 3")
			damage_amount = 30
			is_attacking = true
			hitbox_number = 2
			hitbox_timer.wait_time = 0.35
			hitbox_timer.start()
			
			await(get_tree().create_timer(0.7).timeout)
			hitbox2_collision.disabled = true
			await(get_tree().create_timer(0.3).timeout)
			
			#STEP 4
			if abs(position.x - player_character.position.x) < 60:
				animated_sprite_2d.stop()
				animated_sprite_2d.play("Attack2")
				print("Combo: 3, Step: 4")
				damage_amount = 30
				is_attacking = true
				hitbox_number = 2
				hitbox_timer.wait_time = 0.35
				hitbox_timer.start()
				
				await(get_tree().create_timer(0.7).timeout)
				hitbox2_collision.disabled = true
				await(get_tree().create_timer(0.45).timeout)
				
				#STEP 5
				if abs(position.x - player_character.position.x) < 60:
					
					animated_sprite_2d.play("Attack3")
					print("Combo: 3, Step: 5")
					damage_amount = 50
					is_attacking = true
					hitbox_number = 3
					hitbox_timer.wait_time = 0.5
					hitbox_timer.start()
					
					await(get_tree().create_timer(0.8).timeout)
					hitbox3_collision.disabled = true
					await(get_tree().create_timer(1.2).timeout)
					
					is_attacking = false
					on_cooldown = false
					
				else:
					is_attacking = false
					on_cooldown = false
				
				
			else:
				is_attacking = false
				on_cooldown = false
		else:
			is_attacking = false
			on_cooldown = false
	else:
		is_attacking = false
		on_cooldown = false
		
func attack_combination_four():
	
	#STEP 1 
	animated_sprite_2d.play("Attack1")
	print("Combo: 4, Step: 1")
	damage_amount = 40
	is_attacking = true
	on_cooldown = true
	hitbox_number = 1
	hitbox_timer.wait_time = 0.45
	hitbox_timer.start()
	
	await(get_tree().create_timer(0.7).timeout)
	hitbox1_collision.disabled = true
	await(get_tree().create_timer(0.5).timeout)
	
	#STEP 2
	if abs(position.x - player_character.position.x) < 60:
		
		animated_sprite_2d.play("Attack3")
		print("Combo: 4, Step: 2")
		damage_amount = 50
		is_attacking = true
		on_cooldown = true
		hitbox_number = 3
		hitbox_timer.wait_time = 0.5
		hitbox_timer.start()
		
		await(get_tree().create_timer(0.8).timeout)
		hitbox3_collision.disabled = true
		await(get_tree().create_timer(0.5).timeout)
		
		#STEP 3
		if abs(position.x - player_character.position.x) < 60:
			
			animated_sprite_2d.play("Attack1")
			print("Combo: 4, Step: 3")
			damage_amount = 40
			is_attacking = true
			on_cooldown = true
			hitbox_number = 1
			hitbox_timer.wait_time = 0.45
			hitbox_timer.start()
			
			await(get_tree().create_timer(0.7).timeout)
			hitbox1_collision.disabled = true
			await(get_tree().create_timer(1.2).timeout)
			
			is_attacking = false
			on_cooldown = false
			
		else:
			is_attacking = false
			on_cooldown = false
	else:
		is_attacking = false
		on_cooldown = false
		
func attack_combination_five():
	
	animated_sprite_2d.play("Attack1")
	print("Combo: 5, Step: 1")
	damage_amount = 40
	is_attacking = true
	on_cooldown = true
	hitbox_number = 1
	hitbox_timer.wait_time = 0.45
	hitbox_timer.start()
	
	await(get_tree().create_timer(0.7).timeout)
	hitbox1_collision.disabled = true
	await(get_tree().create_timer(0.4).timeout)
	
	if abs(position.x - player_character.position.x) < 60:
		
		animated_sprite_2d.play("Attack2")
		print("Combo: 5, Step: 2")
		damage_amount = 30
		is_attacking = true
		on_cooldown = true
		hitbox_number = 2
		hitbox_timer.wait_time = 0.35
		hitbox_timer.start()
		
		await(get_tree().create_timer(0.7).timeout)
		hitbox2_collision.disabled = true
		await(get_tree().create_timer(0.45).timeout)
		
		if abs(position.x - player_character.position.x) < 60:
			
			animated_sprite_2d.play("SpecialAttack")
			print("Combo: 5, Step: 3")
			damage_amount = 60
			is_attacking = true
			on_cooldown = true
			hitbox_number = 4
			hitbox_timer.wait_time = 1.35
			hitbox_timer.start()
			
			await(get_tree().create_timer(1.65).timeout)
			sphitbox_collision.disabled = true
			await(get_tree().create_timer(1.2).timeout)
			
			is_attacking = false
			on_cooldown = false
			
		else:
			is_attacking = false
			on_cooldown = false
	else:
		is_attacking = false
		on_cooldown = false

func _on_hitbox_timer_timeout():
	
	if hitbox_number == 1:
		#print("hitbox 1 enabled")
		hitbox1_collision.disabled = false
	elif hitbox_number == 2:
		#print("hitbox 2 enabled")
		hitbox2_collision.disabled = false
	elif hitbox_number == 3:
		#print("hitbox 3 enabled")
		hitbox3_collision.disabled = false
	elif hitbox_number == 4:
		#print("hitbox 4 enabled")
		sphitbox_collision.disabled = false




func _on_hurtbox_area_entered(area : Area2D):
	
	if area.has_node("hitboxCollision"):
		current_health -= GameController.current_damage
		print(current_health)
		UiController.bludimir_health_decreased.emit(current_health)

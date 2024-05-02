extends Node

var current_strength_stat = 0
var current_strength_upgrade_price

var current_health_stat = 0
var current_health_upgrade_price

var current_focus_stat = 0
var current_focus_upgrade_price

var current_damage : float

var enemy_instance = null

var current_souls_held = 0

var last_coffin_slept_position : Vector2

signal souls_counter_changed
signal player_died
signal game_started

var save_path = "user://variable.save"

var player
var loaded = false


func _ready():
	
	
	current_damage = (GameController.current_strength_stat + 20) * 1.2
	souls_counter_changed.connect(on_souls_counter_changed)
	UiController.button_pressed.connect(on_button_pressed)
	UiController._exit_button_pressed.connect(on_exit_button_pressed)
	player_died.connect(on_player_died)
	game_started.connect(on_game_started)
	
	current_strength_upgrade_price = (current_strength_stat * 20) + 500
	current_health_upgrade_price = (current_health_stat * 20) + 500
	current_focus_upgrade_price = (current_focus_stat * 20) + 500

func _process(delta):
	if get_tree().root.get_node("Level") and !loaded:
		player = get_tree().root.get_node("Level").get_node("player")
		loaded = true
		
func on_souls_counter_changed(change_number):
	
	if change_number == -1:
		current_souls_held = 0
	else:
		current_souls_held += change_number

func on_button_pressed(pressed_button: TextureButton):
	
	if pressed_button.name == "SleepButton":
		HealthManager.current_potion_number = HealthManager.max_potion_number
		HealthManager.increase_health(HealthManager.max_health)
		
		last_coffin_slept_position = pressed_button.get_parent().get_node("DetectArea").get_node("position_marker").global_position
		
		var root_node = get_tree().root
		var level_node = root_node.get_node("Level")
		var enemies = level_node.get_node("Enemies").get_children()
		if enemies:
			for enemy in enemies:
				enemy.global_position = enemy.initial_position
				enemy.health_Points = enemy.max_health
				enemy.is_dead = false
				enemy.aggroArea.monitoring = false
				enemy.detect_area.disabled = false
				enemy.current_state = enemy.State.Stopped
				print(enemy.health_Points)
				enemy.visible = true
				for child in enemy.get_children():
					if child is CollisionShape2D:
						child.disabled = false
				
		else:
			print("Haven't found any enemies")

func on_exit_button_pressed():
	var root_node = get_tree().root
	var level_node = root_node.get_node("Level")
	var enemies = level_node.get_node("Enemies").get_children()
	
	if enemies:
		for enemy in enemies:
			enemy.current_state = enemy.State.Idle
	player.current_state = player.State.Idle

func on_player_died(player):
	player.is_dead = false
	GameController.souls_counter_changed.emit(-1)
	HealthManager.increase_health(HealthManager.max_health)
	HealthManager.current_potion_number = HealthManager.max_potion_number
	player.hurtbox.disabled = false
	player.global_position = last_coffin_slept_position
	player.current_state = player.State.Idle
	
	var root_node = get_tree().root
	var level_node = root_node.get_node("Level")
	var enemies = level_node.get_node("Enemies").get_children()
	if enemies:
		for enemy in enemies:
			enemy.global_position = enemy.initial_position
			enemy.health_Points = enemy.max_health
			enemy.is_dead = false
			enemy.aggroArea.monitoring = false
			enemy.detect_area.disabled = false
			enemy.current_state = enemy.State.Idle
			print(enemy.health_Points)
			enemy.visible = true
			for child in enemy.get_children():
				if child is CollisionShape2D:
					child.disabled = false
	

func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(current_strength_stat)
	file.store_var(current_focus_stat)
	file.store_var(current_health_stat)
	file.store_var(current_souls_held)
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		current_strength_stat = file.get_var(current_strength_stat)
		current_focus_stat = file.get_var(current_focus_stat)
		current_health_stat = file.get_var(current_health_stat)
		current_souls_held = file.get_var(current_souls_held)
	else:
		print("no files found")

func on_game_started():
	pass
	

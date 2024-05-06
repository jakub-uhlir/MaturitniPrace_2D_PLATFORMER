extends CanvasLayer

@onready var potion_number = $Potion/PotionNumber
@onready var you_died_text = $YouDied

@onready var loadscreen = $Loadscreen

@onready var coffin_menu = $CoffinMenu
@onready var level_up_menu = $LevelUpMenu
@onready var escape_menu = $EscapeMenu

@onready var level_up_button = $CoffinMenu/VBoxContainer/LevelUpButton

@onready var strength_stat_number = $LevelUpMenu/StrengthButton/StrengthStatNumber
@onready var hp_stat_number = $LevelUpMenu/HpButton/HpStatNumber
@onready var focus_stat_number = $LevelUpMenu/FocusButton/FocusStatNumber
@onready var souls_counter_number = $SoulsCounterBackground/SoulsCounterNumber
@onready var souls_counter_background = $SoulsCounterBackground
var is_sleeping = false

var current_potion_number : int

var main_screen_scene = preload("res://UI/main_screen/main_screen.tscn")

func _ready():
	
	current_potion_number = HealthManager.max_potion_number
	potion_number.text = str(HealthManager.max_potion_number)
	
	strength_stat_number.text = str(GameController.current_strength_stat)
	souls_counter_number.text = str(GameController.current_souls_held)
	
	HealthManager.on_health_increased.connect(on_player_health_changed)
	HealthManager.on_health_decreased.connect(on_player_health_decreased)
	UiController.detect_area_exited.connect(on_detect_area_exited)
	UiController.button_pressed.connect(on_button_pressed)
	GameController.souls_counter_changed.connect(on_souls_counter_changed)
	
func _physics_process(delta):
	on_escape_menu_trigger()

func on_player_health_changed(_current_potion_number : int):
	current_potion_number = _current_potion_number
	potion_number.text = str(current_potion_number)

func on_player_health_decreased(current_player_health):
	if current_player_health == 0:
		var tween = get_tree().create_tween()
		souls_counter_background.visible = false
		souls_counter_number.visible = false
		loadscreen.visible = true
		you_died_text.visible = true
		tween.tween_property(loadscreen,"color",Color(0,0,0,1),3)
		await(get_tree().create_timer(5).timeout)
		souls_counter_background.visible = true
		souls_counter_number.visible = true
		loadscreen.visible = false
		you_died_text.visible = false
		

func on_button_pressed(pressed_button):
	if pressed_button.name == "SleepButton":
		is_sleeping = true
		pressed_button.visible = false
	
		loadscreen.color = Color(0,0,0,0.85)
		loadscreen.visible = true
		coffin_menu.visible = true
	
	
func on_detect_area_exited(detect_area : Area2D):
	
	if detect_area.has_node("coffin_detect_collision") and is_sleeping == true :
		loadscreen.color = Color(0,0,0,0.65)
		loadscreen.visible = false
		coffin_menu.visible = false
		


func _on_exit_button_pressed():
	loadscreen.color = Color(0,0,0,0.65)
	loadscreen.visible = false
	coffin_menu.visible = false
	UiController._exit_button_pressed.emit()


func _on_level_up_button_pressed():
	coffin_menu.visible = false
	level_up_menu.visible = true
	

func _on_exit_button_2_pressed():
	level_up_menu.visible = false
	coffin_menu.visible = true


func _on_strength_button_pressed():
	if GameController.current_strength_upgrade_price < GameController.current_souls_held:
		
		GameController.current_strength_stat += 1 
		GameController.souls_counter_changed.emit(GameController.current_strength_upgrade_price * -1)
		GameController.current_strength_upgrade_price = (GameController.current_strength_stat * 50) + 500
		
		strength_stat_number.text = str(GameController.current_strength_stat)
		GameController.current_damage = (GameController.current_strength_stat + 20) * 1.2
		print("Current damage: ", GameController.current_damage)

func _on_hp_button_pressed():
	if GameController.current_health_upgrade_price < GameController.current_souls_held:
		
		GameController.current_health_stat += 1 
		GameController.souls_counter_changed.emit(GameController.current_health_upgrade_price * -1)
		GameController.current_health_upgrade_price = (GameController.current_health_stat * 50) + 500
		
		hp_stat_number.text = str(GameController.current_health_stat)
		HealthManager.max_health = (GameController.current_health_stat + 100) * 1.2
		HealthManager.current_health = HealthManager.max_health
		print(HealthManager.max_health)

func _on_focus_button_pressed():
	if GameController.current_focus_upgrade_price < GameController.current_souls_held:
		
		GameController.current_focus_stat += 1 
		GameController.souls_counter_changed.emit(GameController.current_focus_upgrade_price * -1)
		GameController.current_focus_upgrade_price = (GameController.current_focus_stat * 50) + 500
		
		focus_stat_number.text = str(GameController.current_focus_stat)

func on_souls_counter_changed(change_number):
	print("souls changed")
	souls_counter_number.text = str(GameController.current_souls_held)

func on_escape_menu_trigger():
	
	if Input.is_action_just_pressed("EscapeMenu") and escape_menu.visible == false:
		escape_menu.visible = true
	elif Input.is_action_just_pressed("EscapeMenu") and escape_menu.visible == true:
		escape_menu.visible = false


func _on_return_to_menu_button_pressed():
	UiController.return_to_menu_pressed.emit()
	SceneSwitcher.switch_scene("res://UI/main_screen/main_screen.tscn")

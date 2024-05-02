extends Node2D

@onready var detect_area = $DetectArea
@onready var position_marker = $CoffinSprite/Marker2D
@onready var sleep_button = $SleepButton
var player

func _ready():
	player = get_tree().root.get_node("Level").get_node("player")




func _on_detect_area_area_entered(area : Area2D):
	if area.has_node("hurtboxCollision"):
		print("coffin detect area entered")
		sleep_button.visible = true


func _on_detect_area_area_exited(area : Area2D):
	if area.has_node("hurtboxCollision"):
		UiController.detect_area_exited.emit(detect_area)
		sleep_button.visible = false
		

func _on_sleep_button_pressed():
	player.current_state = player.State.Stopped
	HealthManager.increase_health(HealthManager.max_health)
	HealthManager.current_potion_number = HealthManager.max_potion_number
	UiController.button_pressed.emit(sleep_button)

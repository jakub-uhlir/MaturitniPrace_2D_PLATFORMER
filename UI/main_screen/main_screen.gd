extends Control

@onready var screen_background = $screen_background
@onready var button_container = $ButtonContainer
@onready var play_button = $ButtonContainer/play_button
@onready var exit_button = $ButtonContainer/exit_button



func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(screen_background,"modulate",Color(1,1,1,1),3)
	tween.tween_property(button_container,"modulate",Color(0.98,0.32,0.27,1),2)

func _process(delta):
	
	if button_container.modulate == Color(0.98,0.32,0.27,1):
		play_button.disabled = false
		exit_button.disabled = false
	
func _on_play_button_pressed():
	SceneSwitcher.switch_scene("res://levels/level.tscn")


func _on_exit_button_pressed():
	
	get_tree().quit()

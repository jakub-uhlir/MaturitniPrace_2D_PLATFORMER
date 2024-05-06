extends Node2D

@onready var full_bar = $FullBar

func _ready():
	
	UiController.bludimir_health_decreased.connect(on_bludimir_health_decreased)
	

func on_bludimir_health_decreased(bludimir_current_health):
	full_bar.scale.x = (bludimir_current_health / 500) * 3.047
	full_bar.position.x = 30

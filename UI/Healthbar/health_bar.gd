extends Node2D

@onready var empty_bar = $EmptyBar
@onready var full_bar = $FullBar



func _ready():
	HealthManager.on_health_changed.connect(on_player_health_changed)
	

func on_player_health_changed(player_current_health : float):
	full_bar.scale.x = player_current_health / HealthManager.max_health
	full_bar.position.x = 13
	print(full_bar.scale.x)

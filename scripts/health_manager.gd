extends Node

var max_health : float 
var max_potion_number : int = 4

var current_potion_number : int
var current_health : float
signal on_health_changed
signal on_health_increased
signal on_health_decreased
#signal player_healed

func _ready():
	max_health = (100 + GameController.current_health_stat) * 1.2
	current_health = max_health
	current_potion_number = max_potion_number
	#player_healed.connect(on_player_healed)
	
func decrease_health(health_amount : int):
	current_health -= health_amount
	
	if current_health < 0:
		current_health = 0
	
	on_health_changed.emit(current_health)
	on_health_decreased.emit(current_health)
	
func increase_health(health_amount : int):
	current_health += health_amount

	
	if current_health > max_health:
		current_health = max_health
		
	on_health_changed.emit(current_health)
	on_health_increased.emit(current_potion_number)

func on_player_healed():
	pass

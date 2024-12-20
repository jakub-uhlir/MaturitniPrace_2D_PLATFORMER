extends AnimatedSprite2D




func _on_spike_area_area_entered(area: Area2D):
	
	if area.name.find("Hurtbox") != -1:
		
		HealthManager.decrease_health(HealthManager.max_health)

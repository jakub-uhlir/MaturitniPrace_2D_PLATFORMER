extends AnimatedSprite2D
@onready var anim_sprite = $"."
@onready var open_button = $OpenButton
var opened = false


func _on_detect_area_area_entered(area):
	if area.has_node("hurtboxCollision") and opened == false:
		open_button.visible = true
	


func _on_detect_area_area_exited(area):
	
	if area.has_node("hurtboxCollision") and opened == false:
		open_button.visible = false


func _on_open_button_pressed():
	
	
	opened = true
	open_button.visible = false
	anim_sprite.play("Openening")
	UiController.chest_opened.emit()
	GameController.current_potion_shards += 1 
	
	

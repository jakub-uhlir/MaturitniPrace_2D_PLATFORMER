extends Node2D
@onready var bludimir_boss = $BludimirBoss

@onready var background_music = $BackgroundMusic
@onready var game_screen = $GameScreen
@onready var boss_trigger_area_collision = $BossTriggerArea/BossTriggerCollision
@onready var fog_gate_collision = $StaticBody2D/CollisionShape2D
@onready var fog_gate = $FogGate

var fight_triggered = false
func _ready():
	background_music.play()
	GameController.player_died.connect(on_player_died)

func _on_background_music_finished():
	background_music.play()


func _on_boss_trigger_area_area_entered(area: Area2D):
	
	if area.name.find("Hurtbox") != -1 and !fight_triggered:
		
		fight_triggered = true
		background_music.stop()
		fog_gate_collision.set_deferred("disabled", false)
		get_tree().call_group("physics", "flush_queries")
		bludimir_boss.current_state = bludimir_boss.State.Attacking
		game_screen.get_node("BludimirHealthbar").visible = true
		bludimir_boss.get_node("SoundtrackPlayer").play()
		
		var tween = get_tree().create_tween()
		tween.tween_property(fog_gate, "modulate", Color(1,1,1,0.80),3)

func on_player_died(player):
	
	fight_triggered = false
	fog_gate_collision.disabled = true
	fog_gate.modulate = Color(0,0,0,0)
	bludimir_boss.get_node("SoundtrackPlayer").stop()
	await(get_tree().create_timer(5).timeout)
	background_music.play()

extends Node2D
func _ready():
	$AnimatedSprite2D.speed_scale = 0.25
	$AnimatedSprite2D.play()
	play_sound("res://Music/Jar of Paper starlight main theme.wav", Vector2(100, 200))

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DIALOGUECUTSCENE.tscn")


""" CALL LIKE:
play_sound("res://sounds/explosion.wav", Vector2(100, 200))
play_sound("res://sounds/echo.wav", Vector2(100, 200))"""
func play_sound(stream_path: String, position: Vector2):
	var sound = load(stream_path)
	if sound == null:
		push_error("Failed to load sound: " + stream_path)
		return
	
	var player = AudioStreamPlayer2D.new()
	add_child(player)
	player.stream = sound
	player.volume_db = -8
	#player.global_position = $Player/Camera2D.global_position
	player.play()
	
	var duration = sound.get_length()
	await get_tree().create_timer(duration).timeout
	player.queue_free()

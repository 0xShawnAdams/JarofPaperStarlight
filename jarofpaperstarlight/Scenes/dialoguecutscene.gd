extends Node2D
@export var dialogue_lines := ["Welcome to A Jar of Paper Starlight!", 
"You are the prince in an \nunfinished story.", 
"Your author has not been \nwell, and you must help him!",
"At any costs, you must obtain the \nsword of starlight and show\n your author that it isnt over"
]
@export var texture: Texture2D
var dialogue_active = true



func _ready():
	$AnimatedSprite2D.speed_scale = 0.25
	$AnimatedSprite2D.play()
	#SignalBus.dialogue_started.emit(dialogue_lines)
	SignalBus.NPCDialogueTrigger.emit(texture, dialogue_lines)
	SignalBus.dialogue_finished.connect(_on_finish)
	play_sound("res://Music/dev.wav", Vector2(100, 200))
	play_sound("res://Music/Laguna Text Scroll.wav", Vector2(100, 200))
	#dialogue_active = true  # Lock player movement
	#emit_signal("dialogue_started")
	#SignalBus.dialogue_started.emit(lines)
	var dlg = $DialogueWindow
	dlg.set_content(texture, dialogue_lines[0])  # show first line immediately
	#dlg.lines = dialogue_lines                        # save all lines in the dialogue window
	dlg.show()

#func _process(delta: float) -> void:
	

func _on_finish():
	get_tree().change_scene_to_file("res://Scenes/Levels/TestLevel.tscn")

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
	#player.global_position = $Player/Camera2D.global_position
	player.play()
	
	var duration = sound.get_length()
	await get_tree().create_timer(duration).timeout
	player.queue_free()

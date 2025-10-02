extends Node2D
var dialogue_active = false
var walking = false
#signal dialogue_started
#signal dialogue_finished
var sound = load("res://Music/Step Loop.wav")
var StepPlayer = AudioStreamPlayer2D.new()

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
	player.volume_db = -4
	player.global_position = $Player/Camera2D.global_position
	player.play()
	
	var duration = sound.get_length()
	await get_tree().create_timer(duration).timeout
	player.queue_free()


func _on_dialogue_finished():
	dialogue_active = false
	
func _ready():
	play_sound("res://Music/dev.wav", Vector2(100, 200))
	#if sound == null:
	#	push_error("Failed to load sound: " + stream_path)
	#	return
	StepPlayer.stream = sound
	add_child(StepPlayer)
	
	var npc := $NPC  # or preload/instantiate
	#npc.connect("dialogue_triggered", Callable(self, "_on_npc_dialogue_triggered"))
	SignalBus.NPCDialogueTrigger.connect(_on_npc_dialogue_triggered)
	#SignalBus.PlayerStepsSound.connect(_on_Player_Walk)
	SignalBus.PlayWalkingAudio.connect(_on_Player_Walk)
	SignalBus.StopWalkingAudio.connect(_on_Stop_Walking)
	SignalBus.PaperStarCollectAudio.connect(_on_Star_Collect)
	SignalBus.PlayerJumpAudio.connect(_on_Player_Jump)
	SignalBus.PlayerLandedAudio.connect(_on_Player_Land)
	SignalBus.InteractAudio.connect(_on_Player_Interact)
	SignalBus.LevelEnd.connect(_on_Level_End)
	

func _on_Level_End():
	# load the next level
	get_tree().change_scene_to_file("res://Scenes/Levels/TestLevel2.tscn")

func _process(delta: float) -> void:

	if (walking):
		if (not StepPlayer.playing):
			StepPlayer.play()
	else:
		StepPlayer.stop()
	#if ($BLOCKER.disabled):
	#	$PaperStar.disabled = false
	
	
func _on_npc_dialogue_triggered(npc_texture: Texture2D, lines: Array):
	print("Dialogue Triggered!")
	play_sound("res://Music/Laguna Text Scroll.wav", Vector2(100, 200))
	dialogue_active = true  # Lock player movement
	#emit_signal("dialogue_started")
	SignalBus.dialogue_started.emit(lines)
	var dlg = $CanvasLayer/DialogueWindow
	dlg.set_content(npc_texture, lines[0])  # show first line immediately
	dlg.lines = lines                        # save all lines in the dialogue window
	dlg.show()
	#emit_signal("dialogue_started")
	
func _on_Player_Jump():
	play_sound("res://Music/Jump.wav", Vector2(100, 200))
func _on_Player_Land():
	play_sound("res://Music/Landing.wav", Vector2(100, 200))
func _on_Player_Land_Wood():
	play_sound("res://Music/Wood Hit.wav", Vector2(100, 200))
func _on_Star_Collect():
	play_sound("res://Music/StarGet.wav", Vector2(100, 200))
func _on_PUzzle_Complete():
	play_sound("res://Music/Puzzle Complete.wav", Vector2(100, 200))
func _on_Page_Turn():
	play_sound("res://Music/Page Turn.wav", Vector2(100, 200))
func _on_Wood_Push():
	play_sound("res://Music/Wood Push.wav", Vector2(100, 200))
func _on_Sword_Swipe():
	play_sound("res://Music/Swipe.wav", Vector2(100, 200))
func _on_Star_Text():
	play_sound("res://Music/StarTextLoop.wav", Vector2(100, 200))
func _on_Player_Interact():
	#play_sound("res://Music/Interact.wav", Vector2(100, 200))
	play_sound("res://Music/Interact.wav", Vector2(100, 200))

func _on_Player_Walk():
	walking = true
#play_sound("res://Music/Step Loop.wav", Vector2(100, 200))
func _on_Stop_Walking():
	walking = false

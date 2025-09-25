extends Area2D

#signal dialogue_triggered(npc_texture: Texture2D, dialogue_lines: Array)

var player_in_area := false
var dialoguetriggered = false;
@export var texture: Texture2D
@export var dialogue_lines := ["Hello!", "Welcome to our village.", "Good luck!"]


"""
func _ready():
	var npc := $NPC  # or preload/instantiate
	npc.connect("dialogue_triggered", Callable(self, "_on_npc_dialogue_triggered"))

func _on_npc_dialogue_triggered():
	dialogue_active = true  # Lock player movement
	var dlg = preload("res://DialogueWindow.tscn").instantiate()
	add_child(dlg)
	dlg.start_dialogue(["Hello traveler!", "Be careful out there."])
	dlg.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))

"""


func _ready():
	# Connect signals from the POV area
	$POVArea.body_entered.connect(_on_body_entered)
	$POVArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":  # Or check group: body.is_in_group("Player")
		player_in_area = true
		dialoguetriggered = false
		#print("PLAYER DETECTED")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func _process(delta):
	if (not dialoguetriggered):
		if player_in_area and Input.is_action_just_pressed("z"):
			#emit_signal("dialogue_triggered")
			var tex = texture
			#emit_signal("dialogue_triggered", tex, dialogue_lines)
			SignalBus.NPCDialogueTrigger.emit(tex, dialogue_lines)
			SignalBus.InteractAudio.emit()
			SignalBus.TextAudio.emit()
			dialoguetriggered = true	
					
			

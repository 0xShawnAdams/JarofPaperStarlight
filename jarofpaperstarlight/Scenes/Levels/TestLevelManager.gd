extends Node2D
var dialogue_active = false
#signal dialogue_started
#signal dialogue_finished

func _on_dialogue_finished():
	dialogue_active = false
	
func _ready():
	var npc := $NPC  # or preload/instantiate
	#npc.connect("dialogue_triggered", Callable(self, "_on_npc_dialogue_triggered"))
	SignalBus.NPCDialogueTrigger.connect(_on_npc_dialogue_triggered)

func _on_npc_dialogue_triggered(npc_texture: Texture2D, lines: Array):
	print("Dialogue Triggered!")
	dialogue_active = true  # Lock player movement
	#emit_signal("dialogue_started")
	SignalBus.dialogue_started.emit(lines)
	var dlg = $CanvasLayer/DialogueWindow
	dlg.set_content(npc_texture, lines[0])  # show first line immediately
	dlg.lines = lines                        # save all lines in the dialogue window
	dlg.show()
	#emit_signal("dialogue_started")

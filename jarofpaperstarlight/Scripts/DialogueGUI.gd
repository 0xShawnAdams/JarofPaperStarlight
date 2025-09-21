extends Control
#signal dialogue_started
#signal dialogue_finished
@export var texture: Texture2D
@export var text: String = "Default text Please replace me"
var just_started := false
@export var char_speed := 0.03   # seconds between characters
var reveal_timer := 0.0
var reveal_count := 0
var current_text := ""

""" HOW TO USE:
var dlg := preload("res://DialogueWindow.tscn").instantiate()
add_child(dlg)
dlg.start_dialogue(["Hello there!", "Nice weather today.", "Goodbye!"])
# Callback func
dlg.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))
# reenable player input
func _on_dialogue_finished():
	dialogue_active = false

"""




@export var advance_key := "z"
@export var skip_key := "x"

var lines := []
var current_line := 0
var active = false

func start_dialogue(npc_texture: Texture2D, new_lines: Array):
	print("STARTED DIALOGUE SYSTEM")
	lines = new_lines
	current_line = 0
	active = true
	#emit_signal("dialogue_started") 
	SignalBus.dialogue_started.emit()
	show()
	_show_line()

func _show_line():
	current_text = lines[current_line]
	reveal_count = 0
	reveal_timer = 0.0
	$HBoxContainer/Label.text = ""

func _process(delta):
	if not active: return
	if just_started:
		just_started = false
		return

	# --- Typewriter effect ---
	if reveal_count < current_text.length():
		if Input.is_action_just_pressed(skip_key):
			_skip_to_end()
			reveal_count = current_text.length()
			$HBoxContainer/Label.text = current_text
		reveal_timer += delta
		if reveal_timer >= char_speed:
			reveal_timer = 0.0
			reveal_count += 1
			$HBoxContainer/Label.text = current_text.substr(0, reveal_count)
	else:
		# Only allow advancing once full line is revealed
		if Input.is_action_just_pressed(advance_key):
			_advance()
		elif Input.is_action_just_pressed(skip_key):
			_skip_to_end()



func _advance():
	current_line += 1
	if current_line >= lines.size():
		_end_dialogue()
	else:
		_show_line()

func _skip_to_end():
	current_line = lines.size() - 1
	_show_line()

func _end_dialogue():
	active = false
	hide()
	# Emit a signal so player control can resume
	#emit_signal("dialogue_finished")
	SignalBus.dialogue_finished.emit()
	print("Dialogue End signal")



func _ready():
	$HBoxContainer/TextureRect.texture = texture
	$HBoxContainer/Label.text = text
	#SignalBus.NPCDialogueTrigger.connect(start_dialogue(lines))
	#SignalBus.dialogue_started.connect(Callable(self, "start_dialogue"))
	SignalBus.NPCDialogueTrigger.connect(Callable(self, "start_dialogue"))

	#SignalBus.dialogue_started.connect(start_dialogue(lines))
	#SignalBus.dialogue_finished.connect(_end_dialogue)
	
func set_content(tex: Texture2D, dialogue: String):
	$HBoxContainer/TextureRect.texture = tex
	$HBoxContainer/Label.text = dialogue
	

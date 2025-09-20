extends Control
signal dialogue_started
signal dialogue_finished
@export var texture: Texture2D
@export var text: String = "Default text Please replace me"

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
var active := false

func start_dialogue(new_lines: Array):
	lines = new_lines
	current_line = 0
	active = true
	emit_signal("dialogue_started") 
	show()
	_show_line()

func _show_line():
	$HBoxContainer/Label.text = lines[current_line]

func _process(delta):
	if not active:
		return

	# Only listen for Z/X while active
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
	emit_signal("dialogue_finished")



func _ready():
	$HBoxContainer/TextureRect.texture = texture
	$HBoxContainer/Label.text = text

func set_content(tex: Texture2D, dialogue: String):
	$HBoxContainer/TextureRect.texture = tex
	$HBoxContainer/Label.text = dialogue
	

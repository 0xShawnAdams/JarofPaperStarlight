extends StaticBody2D
@export var disabled = false

func disable_object():
	visible = false                           # Hide the sprite
	disabled = true         # Disable collisions

func enable_object():
	visible = true
	disabled = false


func _on_button_pressed():
	disable_object()
	$CollisionShape2D.disabled = true
	SignalBus.SpawnPaperStar.emit()
	
func _ready():
	connect("pressed", _on_button_pressed)

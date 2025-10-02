extends Area2D
var player_in_area = false


func _ready():
	# Connect signals from the POV area
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func _on_body_entered(body):
	if body.name == "Player":  # Or check group: body.is_in_group("Player")
		player_in_area = true
		SignalBus.LevelEnd.emit()

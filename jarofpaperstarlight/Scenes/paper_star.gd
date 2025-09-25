extends Area2D

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  # Or check group: body.is_in_group("Player")
		print("STAR DETECTED PLAYER")
		SignalBus.JarCountIncrement.emit()
		SignalBus.PaperStarCollectAudio.emit()

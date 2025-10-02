extends Area2D
@export var disabled = false
#@export var visible = false


func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	SignalBus.SpawnPaperStar.connect(_on_Spawn)
	#disabled = true
	$CollisionShape2D2.disabled =  false
	#visible = false
	

func _on_body_entered(body):
	if body.name == "Player" && not disabled:  # Or check group: body.is_in_group("Player")
		print("STAR DETECTED PLAYER")
		SignalBus.JarCountIncrement.emit()
		SignalBus.PaperStarCollectAudio.emit()
		$CollisionShape2D2.disabled = true
		$Area2D/CollisionShape2D.disabled = true
		visible = false
		disabled = true


func _on_Spawn():
	print("Spawned local star")
	disabled = false
	$CollisionShape2D2.disabled = false
	visible = true
	

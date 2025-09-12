extends Node
var score = 0;

func _ready():
	new_game()
	
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	#$Player.start()
	#$StartTimer.start()

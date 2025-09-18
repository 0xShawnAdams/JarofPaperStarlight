extends Node
var score = 0;
var screen_size # Size of the game window.

func _ready():
	new_game()
	#screen_size = get_viewport_rect().size
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	#$Player.start()
	#$StartTimer.start()

#func _process(delta: float):#
	#if ($Player.transform.x > screen_size):
	#	$CameraPivot.position.x += 1000;

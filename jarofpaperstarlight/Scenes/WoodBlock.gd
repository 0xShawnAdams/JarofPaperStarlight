extends RigidBody2D
var player_in_area := false
var triggered = false;
@export var texture: Texture2D
var left = false
var right = false

func _ready():
	# Connect signals from the POV area
	$POV.body_entered.connect(_on_body_entered)
	$POV.body_exited.connect(_on_body_exited)

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func _on_body_entered(body):
	if body.name == "Player":  # Or check group: body.is_in_group("Player")
		player_in_area = true
		triggered = false
	#if left:
	#	push_block(Vector2.LEFT)
	#elif right:
	#	push_block(Vector2.RIGHT)
	if body.global_position.x < global_position.x:
		right = true
		left = false

	else:
		left = true
		right = false

func push_block(direction: Vector2):
	var motion = direction * 100  # tile size
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + motion)
	var result = space_state.intersect_ray(query)

	if result.is_empty():
		global_position += motion



		
func _process(delta):
	if (not triggered):
		if player_in_area and Input.is_action_just_pressed("z"):
			#emit_signal("dialogue_triggered")
			var tex = texture
			#emit_signal("dialogue_triggered", tex, dialogue_lines)
			#SignalBus.NPCDialogueTrigger.emit(tex, dialogue_lines)
			SignalBus.InteractAudio.emit()
			#SignalBus.TextAudio.emit()
			triggered = true
			#itriggered = true
		#if left:
		#	push_block(Vector2.LEFT)
		#elif right:
		#	push_block(Vector2.RIGHT)
			if left:
				global_position += Vector2.LEFT * 100
			elif right:
				global_position += Vector2.RIGHT * 100

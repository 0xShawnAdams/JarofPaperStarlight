extends CharacterBody2D
signal hit

var dialogue_active = false

@export var speed := 400.0
@export var accel := 2500.0      # how fast to reach full speed
@export var deccel := 3000.0     # how fast to stop
@export var jump_speed := -900.0      # Initial jump impulse (negative = up)
@export var gravity := 2000.0         # Normal gravity
@export var fall_gravity := 3000.0    # Stronger gravity when falling
@export var low_jump_gravity := 3500.0# Extra gravity if jump is released early
var screen_size
var falling = false

func _ready():
	screen_size = get_viewport_rect().size
	SignalBus.dialogue_started.connect(_on_dialogue_started)
	SignalBus.dialogue_finished.connect(_on_dialogue_finished)
	#var dlg = get_node("/root/Testlevel/DialogueWindow")
	#var dialogue_window := get_node("../CanvasLayer/DialogueWindow")
	#dialogue_window.connect("dialogue_started", Callable(self, "_on_dialogue_started"))
	#dialogue_window.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))
	
func _on_dialogue_started():
	print("Player is aware of dialogue")
	dialogue_active = true
	#$DialogueWindow.show()

func _on_dialogue_finished():
	dialogue_active = false
	#$DialogueWindow.hide()

	
func _physics_process(delta):
	# Apply gravity
	if (dialogue_active):
		return
	if (falling and is_on_floor()):
		falling = false
		SignalBus.PlayerLandedAudio.emit()
	
	# Jump start
	if is_on_floor() and Input.is_action_just_pressed("move_up"):
		velocity.y = jump_speed
		SignalBus.PlayerJump.emit()
		falling = true
	# Gravity
	if velocity.y > 0:  # Falling
		velocity.y += fall_gravity * delta
	else:               # Rising
		velocity.y += gravity * delta
		# If jump is released early, increase gravity for a short hop
		if not Input.is_action_pressed("move_up"):
			velocity.y += low_jump_gravity * delta
	
	# Horizontal movement
	#var direction := 0.0
	#if Input.is_action_pressed("move_right"):
	#	direction += 1.0
	#if Input.is_action_pressed("move_left"):
	#	direction -= 1.0
	#velocity.x = direction * speed
	var input_dir := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var target_speed := input_dir * speed

	if input_dir != 0:
		velocity.x = move_toward(velocity.x, target_speed, accel * delta)
		
	else:
		velocity.x = move_toward(velocity.x, 0, deccel * delta)


	# Move character with collision
	move_and_slide()

	# Handle animations
	if input_dir != 0:
		$AnimatedSprite2D.flip_h = input_dir < 0   # true when moving left
		$AnimatedSprite2D.play("Walk")
		SignalBus.PlayerStepsSound.emit()
	else:
		$AnimatedSprite2D.stop()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

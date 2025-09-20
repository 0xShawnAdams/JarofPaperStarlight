extends CharacterBody2D
signal hit


@export var speed := 400.0
@export var accel := 2500.0      # how fast to reach full speed
@export var deccel := 3000.0     # how fast to stop
@export var jump_speed := -800.0      # Initial jump impulse (negative = up)
@export var gravity := 2000.0         # Normal gravity
@export var fall_gravity := 3000.0    # Stronger gravity when falling
@export var low_jump_gravity := 3500.0# Extra gravity if jump is released early
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	# Apply gravity
	
	# Jump start
	if is_on_floor() and Input.is_action_just_pressed("move_up"):
		velocity.y = jump_speed

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

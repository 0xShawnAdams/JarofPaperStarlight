extends CharacterBody2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var jump_speed = -700.0
var screen_size # Size of the game window.
var jumping = false
#var delta = 0;
# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	screen_size = get_viewport_rect().size
	
#func _physics_process(delta):
#	#velocity.y += gravity * delta # adds gravity
#	# Vertical Velocity
#	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
#		#velocity.y = velocity.y - (gravity * delta)
#		#velocity.y += jump_speed
#		velocity.y += gravity * delta
	
	#if jumping:
	#	if ()
	
	# Using move_and_collide.
	#var collision = move_and_collide(velocity * delta)
	#if collision:
	#	print("I collided with ", collision.get_collider().name)

	# Using move_and_slide.
#	move_and_slide()
#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
		#print("I collided with ", collision.get_collider().name)	
	# _process(delta)
func  _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up") and is_on_floor():
		#velocity.y -= 1
		velocity.y = jump_speed #* delta
		#position.y -= jump_speed 
		jumping = true;
	#else:
	#	jumping = false

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "Walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "Up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#velocity.y = velocity.y - (gravity * delta)
		#velocity.y += jump_speed
		velocity.y += gravity * delta
		
	position += velocity * delta
	
	#position = position.clamp(Vector2.ZERO, screen_size)
	# Using move_and_slide.
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print("I collided with ", collision.get_collider().name)	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

extends Control

@export var Count = 0
@export var texture: Texture2D

func _ready():
	SignalBus.SetJarCount.connect(setcount)
	SignalBus.JarCountIncrement.connect(jarinc)
	$HBoxContainer/AnimatedSprite2D2.connect("animation_finished", Callable(self, "_on_animation_finished"))
	

func _on_animation_finished():
	# This will stop the animation once it's finished
	$HBoxContainer/AnimatedSprite2D2.stop()

func jarinc():
	Count = Count +1
	$HBoxContainer/AnimatedSprite2D2.play()

func setcount(count: int):
	Count = count

func _process(delta: float):
	$HBoxContainer/Label.text = "x %d" % Count
	if Count == 0:
		$HBoxContainer/AnimatedSprite2D.frame = 0
	if Count > 0:
		$HBoxContainer/AnimatedSprite2D.frame = 1
	if Count > 3:
		$HBoxContainer/AnimatedSprite2D.frame = 2
	if Count > 5:
		$HBoxContainer/AnimatedSprite2D.frame = 3

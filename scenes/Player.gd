extends CharacterBody2D

@export var maxSpeed = 300
@export var accel = 1500
@export var friction = 1500

@onready var axis = Vector2.ZERO
@onready var joystick = get_tree().get_first_node_in_group("joystick")


enum{Idle, Run, Walk}
var state = Idle
var clockPos : String = "1"

var canInteract = false
var interactable : Area2D = null

func _ready() -> void:
	joystick.connect("clicked", changeCam)
	joystick.connect("released", interact)

func _physics_process(delta):
	movement(delta)
	move_and_slide()
	

func _process(delta: float) -> void:
	animate() #<-- uncomment when animations are complete
	
	if !$Area2D/interactingTImer.is_stopped():
		$CanvasLayer/interactableTimer.value = $Area2D/interactingTImer.time_left*100 #*10 - choppy effect

func movement(delta):
	var angle = joystick.getJsAngle()
	if angle != 0 : rotation = joystick.getJsDir().angle()
	var joystickStrength = joystick.getJsPos()/joystick.maxRadius
	
	if joystickStrength == 0:
		applyFriction(friction*delta)
		state = Idle
	elif joystickStrength > .5:
		if $Camera2D.zoomed == false:
			state = Walk
		else:
			state = Run
		velocity = getMovementVector(angle) * maxSpeed

func changeCam():
	print("changeCam")
	if $Camera2D.zoomed == true:
		$Camera2D.zoom = Vector2(1,1)
		$Camera2D.zoomed = false
		maxSpeed = 100
	else:
		$Camera2D.zoom = Vector2(3,3)
		$Camera2D.zoomed = true
		maxSpeed = 300

func applyFriction(amount):
	if velocity.length()>amount:
		velocity-=velocity.normalized()*amount
	else:
		velocity= Vector2.ZERO

func getMovementVector(angle):
	var radian = deg_to_rad(angle)
	return Vector2(cos(radian), sin(radian))

func getClockPos(angle):
	if angle >= 337.5 or angle < 22.5:
		return "3"
	elif angle >= 22.5 and angle < 67.5:
		return"5"
	elif angle >= 67.5 && angle < 112.5:
		return"6"
	elif angle >= 112.5 && angle < 157.5:
		return"7"
	elif angle >= 157.5 && angle < 202.5:
		return "9"
	elif angle > 202.5 && angle < 247.5:
		return "11"
	elif angle >= 247.5 && angle < 292.5:
		return "12"
	elif angle > 292.5 && angle < 337.5:
		return "1"

func animate() -> void:
	match state:
		#8 different angles of each
		Run:
			$AnimatedSprite2D.play("run")
		Walk:
			$AnimatedSprite2D.play("walk")
		Idle:
			$AnimatedSprite2D.play("idle")

func interact():
	if interactable != null && interactable.completed == false:
		print(interactable.completed)
		$CanvasLayer/interactableTimer.max_value = interactable.timeToCollect*100
		$Area2D/interactingTImer.start(interactable.timeToCollect)
		if !$CanvasLayer/interactableTimer.visible: $CanvasLayer/interactableTimer.show()

func soundsLocked():
	print("door locked")
	$"CanvasLayer/Pixilart-sprite2".show()
	$"CanvasLayer/Pixilart-sprite2".play()
	$"CanvasLayer/Pixilart-sprite2".animation_finished.connect($"CanvasLayer/Pixilart-sprite2".queue_free)
	

func _on_interacting_t_imer_timeout() -> void:
	
	interactable.complete.emit()

func _on_area_2d_area_entered(area: Area2D) -> void:
	interactable = area
	print(interactable)

func _on_area_2d_area_exited(area: Area2D) -> void:
	interactable = null
	$Area2D/interactingTImer.stop()
	$CanvasLayer/interactableTimer.hide()
	#stop interacting timer

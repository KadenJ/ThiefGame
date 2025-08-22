extends CharacterBody2D

@export var maxSpeed = 300
@export var accel = 1500
@export var friction = 1500

@onready var axis = Vector2.ZERO
@onready var joystick = get_tree().get_first_node_in_group("joystick")

enum{Idle, Run, Walk}
var state = Idle
var clockPos : String = "1"


func _physics_process(delta):
	movement(delta)
	move_and_slide()
	
	
	#animate() #<-- uncomment when animations are complete

func movement(delta):
	var angle = joystick.getJsAngle()
	if angle != 0 : clockPos = str(getClockPos(angle))
	var joystickStrength = joystick.getJsPos()/joystick.maxRadius
	
	if joystickStrength == 0:
		applyFriction(friction*delta)
		state = Idle
		#play Idle
	elif joystickStrength > .5:
		if $Camera2D.zoomed:
			state = Run
		else:
			state = Walk
		velocity = getMovementVector(angle) * maxSpeed
	

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
			$AnimatedSprite2D.play("run" + clockPos)
		Walk:
			$AnimatedSprite2D.play("walk" + clockPos)
		Idle:
			$AnimatedSprite2D.play("idle" + clockPos)

extends CharacterBody2D

@export var maxSpeed = 300
@export var accel = 1500
@export var friction = 1500

@onready var axis = Vector2.ZERO

enum{Idle, Run, Walk}
var state = Idle


func _physics_process(delta):
	move(delta)
	#animate()

func getInputAxis():
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return axis.normalized()
	

func move(delta):
	axis = getInputAxis()
	if axis == Vector2.ZERO:
		state = Idle
		applyFriction(friction*delta)
	else: 
		if $Camera2D.zoomed:
			state = Run
		else: 
			state = Walk
		applyMovement(axis*accel*delta)
		#blendPos = axis
		animate()
	move_and_slide()

func applyFriction(amount):
	if velocity.length()>amount:
		velocity-=velocity.normalized()*amount
	else:
		velocity= Vector2.ZERO


func applyMovement(_accel):
	velocity+=_accel
	velocity = velocity.limit_length(maxSpeed)

func animate() -> void:
	$".".rotation = axis.angle()
	#SM.travel(animTreeStateKey[state])
	#animationTree.set(blendPosPath[state], blendPos)

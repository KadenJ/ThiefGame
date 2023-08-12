extends CharacterBody2D

@export var maxSpeed = 300
@export var accel = 1500
@export var friction = 200

@onready var axis = Vector2.ZERO

func _physics_process(delta):
	move(delta )
	

func getInputAxis():
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return axis.normalized()
	

func move(delta):
	axis = getInputAxis()
	if axis == Vector2.ZERO:
		applyFriction(friction*delta)
	else: 
		applyMovement(axis*accel*delta)
	move_and_slide()

func applyFriction(amount):
	if velocity.length()>amount:
		velocity-=velocity.normalized()*amount
	else:
		velocity= Vector2.ZERO
		

func applyMovement(accel):
	velocity+=accel
	velocity = velocity.limit_length(maxSpeed)

#add sneak

extends CharacterBody2D

@export var maxSpeed = 300
@export var accel = 1500
@export var friction = 1500

@onready var axis = Vector2.ZERO

enum{Idle, Run, Walk}
var state = Idle
@onready var animationTree = $AnimationTree
@onready var SM = animationTree["parameters/playback"]
var blendPos : Vector2 = Vector2.ZERO
var blendPosPath = [
	"parameters/idle/IdleBlendSpace2D/blend_position",
	"parameters/run/BlendSpace2D/blend_position",
	"parameters/walk/BlendSpace2D/blend_position"
]
var animTreeStateKey = ["idle", "run", "walk"]


func _physics_process(delta):
	move(delta)
	animate()

func getInputAxis():
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return axis.normalized()
	

func move(delta):
	#if camera.zoomed == true run anim else walk
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
		blendPos = axis
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
	SM.travel(animTreeStateKey[state])
	animationTree.set(blendPosPath[state], blendPos)

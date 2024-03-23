extends State
class_name GWander
 
@export var guard:CharacterBody2D
@export var moveSpeed:=100.0

var moveDirection: Vector2
var wanderTime: float

signal recruited

func _ready():
	recruited.connect(changeState)

func randomizeWander():
	moveDirection=Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wanderTime = randfn(1,2)
	guard.rotation = moveDirection.angle()
	
func Enter():
	randomizeWander()

func Update(delta: float):
	if wanderTime > 0:
		wanderTime-=delta
	else:
		randomizeWander()
	
func Physics_Update(_delta:float):
	if guard:
		guard.velocity = moveDirection* moveSpeed
	#guard.rotate(guard.velocity.angle())
	#var direction = guard.global_position - Player.global_position 
	

func _on_area_2d_body_entered(_body):
	changeState()
	
func changeState():
	Transitioned.emit(self, "GChase")
	
	

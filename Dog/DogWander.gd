extends State
class_name DWander
 
@export var dog:CharacterBody2D
@export var moveSpeed:=125.0

#var Player: CharacterBody2D

var moveDirection: Vector2
var wanderTime: float

func randomizeWander():
	moveDirection=Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wanderTime = randfn(.8,1.4)
	dog.rotation = moveDirection.angle()
	
func Enter():
	#Player = get_tree().get_first_node_in_group("Player")
	randomizeWander()

func Update(delta: float):
	if wanderTime > 0:
		wanderTime-=delta
	else:
		randomizeWander()
	
func Physics_Update(_delta:float):
	if dog:
		dog.velocity = moveDirection* moveSpeed
	#guard.rotate(guard.velocity.angle())
	#var direction = guard.global_position - Player.global_position 
	

	
	

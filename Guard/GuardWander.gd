extends State
class_name GWander
 
@export var guard:CharacterBody2D
@export var moveSpeed:=100.0

#var Player: CharacterBody2D

var moveDirection: Vector2
var wanderTime: float

func randomizeWander():
	moveDirection=Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wanderTime = randfn(1,2)
	
func Enter():
	#Player = get_tree().get_first_node_in_group("Player")
	randomizeWander()

func Update(delta: float):
	if wanderTime > 0:
		wanderTime-=delta
	else:
		randomizeWander()
	
func Physics_Update(_delta:float):
	if guard:
		guard.velocity = moveDirection* moveSpeed
	
	#var direction = guard.global_position - Player.global_position 
	
	#on area enter
	#if direction.length() < 300:
		#Transitioned.emit(self, "GWander")

func _on_area_2d_body_entered(_body):
	print("found player1")
	Transitioned.emit(self, "GChase")

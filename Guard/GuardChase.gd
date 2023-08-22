extends State
class_name GChase

@export var Guard: CharacterBody2D
@export var ChaseSpeed:= 150
@export var chaseDistance = 4

var Player: CharacterBody2D

func Enter():
	Player = get_tree().get_first_node_in_group("Player")
	
func Physics_Update(_delta: float):
	var direction = Player.global_position - Guard.global_position
	#change to if in cone chase
	#on area enter
	if direction.length() < 300:
		Guard.velocity= direction.normalized()*ChaseSpeed
	else:
		Guard.velocity = Vector2()
	
	#on area exit
	if direction.length() > 301:
		print(direction.length())
		Transitioned.emit(self,"GWander")

func _on_area_2d_body_exited(_body):
	print("player lost")
	#give timer to wait 1-2 seconds before switch
	Transitioned.emit(self,"GWander")

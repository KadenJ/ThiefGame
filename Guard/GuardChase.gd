extends State
class_name GChase

@onready var timer = $"../../Timer"
@export var Guard: CharacterBody2D
@export var ChaseSpeed:= 150

var Player: CharacterBody2D

func Enter():
	Player = get_tree().get_first_node_in_group("Player")
	
func Physics_Update(delta: float):
	var direction = Player.global_position - Guard.global_position
	
	#change to if in cone chase
	#on area enter
	if direction.length() < 300:
		Guard.velocity= direction.normalized()*ChaseSpeed
		Guard.look_at(Player.position)
	else:
		Guard.velocity = Vector2()
	
	#on area exit
	if direction.length() > 350:
		print(direction.length())
		Transitioned.emit(self,"GWander")

func _on_area_2d_body_exited(_body):
	print("player lost ", timer.time_left)
	
	#timer doesn't work
	timer.start()
	if timer.timeout:
		print("give up")
		Transitioned.emit(self,"GWander")
	


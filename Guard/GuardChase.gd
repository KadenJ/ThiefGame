extends State
class_name GChase

@export var Guard: CharacterBody2D
@export var ChaseSpeed:= 150

@onready var timer = $"../../Timer"

var Player: CharacterBody2D

func _ready():
	timer.connect("timeout", changeState)
	

func Enter():
	print("GChase")
	Player = get_tree().get_first_node_in_group("Player")
	

func Physics_Update(_delta: float):
	var direction = Player.global_position - Guard.global_position
	
	#on area enter
	if direction.length() < 300:
		Guard.velocity= direction.normalized()*ChaseSpeed
		Guard.look_at(Player.position)
	else:
		Guard.velocity = Vector2()
	
	#on area exit
	if direction.length() > 350:
		Transitioned.emit(self,"GWander")
		
	

func changeState():
	print("giveUp")
	Transitioned.emit(self, "GWander")


func _on_area_2d_body_exited(_body):
	timer.start()
	


func _on_catcher_body_entered(_body):
	print("player caught")
	Events.guardCaught.emit()

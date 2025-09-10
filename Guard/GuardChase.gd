extends State
class_name GChase

@export var Guard: CharacterBody2D
@export var ChaseSpeed:= 200
@export var Goal: Node = null

@onready var navAgent: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var timer = $Timer
@onready var  Player : CharacterBody2D

func _ready():
	timer.connect("timeout", changeState)
	

func Enter():
	Player = get_tree().get_first_node_in_group("Player")
	Goal = Player
	if Events.isMuted == false:
		$AudioStreamPlayer2D.play()
		
	timer.start()

func Physics_Update(_delta: float):
	var direction = Player.global_position - Guard.global_position
	
	#on area enter
	if direction.length() < 400:
		#new pathfinding
		if is_instance_valid(Goal):
			navAgent.target_position = Goal.global_position
		var currentNavPos = Guard.global_position
		var nextNavPos = navAgent.get_next_path_position()
		Guard.velocity = currentNavPos.direction_to(nextNavPos) * ChaseSpeed
		Guard.look_at(currentNavPos.direction_to(nextNavPos))
	else:
		if navAgent.is_navigation_finished():
			changeState()
		
		#og chase
		#Guard.velocity= direction.normalized()*ChaseSpeed
		#Guard.look_at(Player.position)
	#else:
		#Guard.velocity = Vector2()
	
	

func changeState():
	print("giveup")
	Transitioned.emit(self, "GWander")



func _on_catcher_body_entered(_body):
	Events.guardCaught.emit()

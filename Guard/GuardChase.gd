extends State
class_name GChase

@export var Guard: CharacterBody2D
@export var ChaseSpeed:= 200
@export var Goal: Node = null

@onready var navAgent: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var timer = $"../Timer"
@onready var  Player : CharacterBody2D

func _ready():
	pass
	

func Enter():
	timer.connect("timeout", changeState)
	Player = get_tree().get_first_node_in_group("Player")
	Goal = Player
	if Events.isMuted == false:
		$AudioStreamPlayer2D.play()
		
	if get_parent().alertLevel < 2:
		timer.start(2)
	if get_parent().alertLevel == 2:
		timer.start(3)
	if get_parent().alertLevel > 3:
		timer.start(5)
		#can recruit passing guards

func Physics_Update(_delta: float):
	var direction = Player.global_position - Guard.global_position
	
	#on area enter
	if direction.length() < 250:
		#new pathfinding
		if is_instance_valid(Goal):
			navAgent.target_position = Goal.global_position
		var currentNavPos = Guard.global_position
		var nextNavPos = navAgent.get_next_path_position()
		Guard.velocity = currentNavPos.direction_to(nextNavPos) * ChaseSpeed
		Guard.look_at(Player.position)
	else:
		if navAgent.is_navigation_finished():	
			changeState()
		


func changeState():
	print("giveup")
	timer.disconnect("timeout", changeState)
	Transitioned.emit(self, "GWander")



func _on_catcher_body_entered(_body):
	Events.guardCaught.emit()

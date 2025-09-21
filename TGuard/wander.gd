extends State
class_name Wander

@export var guard : CharacterBody2D

var dir : Vector2
var speed = 100
var currentTarget : Node2D
var isA : bool = true

func Enter():
	currentTarget = get_child(1)
	

func Physics_Update(_delta : float):
	dir = currentTarget.global_position - guard.global_position
	guard.velocity = dir.normalized() * speed
	guard.look_at(currentTarget.position)
	
	isAtPoint()

func isAtPoint():
	if dir.length() < 10:
		isA = !isA
		speed=0
		await get_tree().create_timer(2).timeout
		
		if isA: currentTarget = get_child(1)
		else: currentTarget = get_child(0)
		
		speed = 100

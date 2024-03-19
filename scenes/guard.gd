extends CharacterBody2D
class_name guardEnemy

var Player: CharacterBody2D

func _ready():
	Player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(_delta):
	move_and_slide()
	
	if velocity.length() >0:
		pass
		#play animation
		

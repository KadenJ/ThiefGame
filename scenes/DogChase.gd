extends State
class_name DChase

@export var Dog: CharacterBody2D
@export var ChaseSpeed = 175

var Player : CharacterBody2D

func Enter():
	Player = get_tree().get_first_node_in_group("Player")
	
func Physics_Update(_delta: float):
	var direction = Player.global_position - Dog.global_position
	Dog.velocity = direction.normalized() * ChaseSpeed
	Dog.look_at(Player.position)
	
	
	
	
func _on_recruit_range_body_entered(guard):
	#sends signal, but not to the right place
	if $"..".currentState == self:
		guard.get_node("StateMachine/GWander").emit_signal("recruited")

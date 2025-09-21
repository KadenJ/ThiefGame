extends State
class_name DChase

@export var Dog: CharacterBody2D
@export var ChaseSpeed = 175

var Player : CharacterBody2D

func Enter():
	Player = get_tree().get_first_node_in_group("Player")
	if Events.isMuted == false:
		$AudioStreamPlayer2D.play()
	
func Physics_Update(_delta: float):
	var direction = Player.global_position - Dog.global_position
	Dog.velocity = direction.normalized() * ChaseSpeed
	Dog.look_at(Player.position)
	if $"..".currentState == self:
		for guard in $"../../recruitRange".get_overlapping_bodies():
			guard.get_node("StateMachine/GWander").emit_signal("recruited")
	


func _on_recruit_range_body_entered(guard):
	if $"..".currentState == self:
		guard.get_node("StateMachine/GWander").emit_signal("recruited")

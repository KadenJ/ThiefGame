class_name PowerUp
extends Area2D

var player
@export var powerTime : float

func _on_body_entered(body):
	if player == null:
		player = body
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	
	
	player.set_collision_layer_value(4, false)
	player.set_modulate("ffffff5a")
	$powerTimer.start(powerTime)
	#set wait time of timer and start

func _on_timer_timeout():
	player.set_collision_layer_value(4, true)
	player.set_modulate("ffffff")
	print("expired")
	call_deferred("queue_free")

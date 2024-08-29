class_name PowerUp
extends Area2D

var player
@export var powerTime : float


func _on_body_entered(body):
	hide()
	$CollisionShape2D.disabled = true
	player = body
	
	player.set_collision_layer_value(4, false)
	player.set_modulate("ffffff5a")
	$powerTimer.start(powerTime)
	#set wait time of timer and start


func _on_timer_timeout():
	player.set_collision_layer_value(4, true)
	player.set_modulate("ffffff")
	print("expired")
	call_deferred("queue_free")

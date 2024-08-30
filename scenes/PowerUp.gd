class_name PowerUp
extends Area2D

var player
@export var powerTime : float
signal collected
signal wornOff

#changes playr layer on entering
#can make to signal is emmitted and make this a class
#add onsignalemit to powerup child node script to do effect
func _on_body_entered(body):
	if player == null:
		player = body
		#return player
	$CollisionShape2D.set_deferred("disabled", true)
	collected.emit()
	hide()
	
	#get rid
	#player.set_collision_layer_value(4, false)
	#player.set_modulate("ffffff5a")
	
	$powerTimer.start(powerTime)
	

func _on_timer_timeout():
	#get rid
	#player.set_collision_layer_value(4, true)
	#player.set_modulate("ffffff")
	
	print("expired")
	wornOff.emit()
	call_deferred("queue_free")

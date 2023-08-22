extends CharacterBody2D
class_name guardEnemy

func _physics_process(delta):
	move_and_slide()
	
	if velocity.length() >0:
		pass
		#play animation

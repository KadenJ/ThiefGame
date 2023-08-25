extends Camera2D

var zoomed = true

func _input(event):
	if event.is_action_pressed("CameraControl"):
		if zoomed == true:
			zoom = Vector2(1,1)
			zoomed = false
		else:
			zoom = Vector2(3,3)
			zoomed = true
		

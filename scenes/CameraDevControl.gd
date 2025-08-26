extends Camera2D

var zoomed = true

func _input(event):
	if event.is_action_pressed("CameraControl"):
		if zoomed == true:
			zoom = Vector2(1,1)
			print("sneak")
			zoomed = false
			get_parent().maxSpeed = 100
		else:
			zoom = Vector2(3,3)
			zoomed = true
			get_parent().maxSpeed = 300

func walkCam():
	if zoomed == false:
		zoom = Vector2(1,1)
		get_parent().maxSpeed = 100
		zoomed = true
	print(zoom)

func runCam():
	if zoomed == true:
		zoom = Vector2(3,3)
		
		get_parent().maxSpeed = 300
		zoomed = false
	print(zoom)

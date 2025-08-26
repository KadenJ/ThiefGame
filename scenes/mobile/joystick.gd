extends TouchScreenButton

@onready var knob: Sprite2D = $Sprite2D
@onready var maxRadius = shape.radius
@onready var knobCenter = texture_normal.get_size()/2

signal clicked
var touched : bool = false

func _process(delta: float) -> void:
	if touched:
		knob.position = knobCenter + (knob.position -knobCenter).limit_length(maxRadius)
	else:
		knob.position = knobCenter

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.double_tap:
			clicked.emit()
		if event.pressed:
			if event.position.distance_to(global_position+knobCenter)<maxRadius:
				touched = true
				
				knob.global_position
		else:
			touched = false
	elif event is InputEventScreenDrag:
		if event.position.distance_to(global_position+knobCenter)<maxRadius or touched:
			knob.global_position = event.position
		
		print(getJsPos())
	

func getJsDir():
	var dir = knob.position - knobCenter
	return dir

func getJsAngle():
	var dir = getJsDir()
	var rad = rad_to_deg(dir.angle())
	return fmod((rad+360), 360)

func getJsPos():
	var dir = ((knob.position.x - knobCenter.x) ** 2) + ((knob.position.y - knobCenter.y) **2)
	var dir2 = sqrt(dir)
	return clampf(dir2, 0, maxRadius)

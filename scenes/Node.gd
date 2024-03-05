extends State
class_name StartUp
@export var initialState = "Wander" #node name not class name
func Enter():
	await get_tree().create_timer(1).timeout
	print("GO TIME")
	Transitioned.emit(self, initialState)

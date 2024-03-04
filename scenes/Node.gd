extends State
class_name StartUp

func Enter():
	await get_tree().create_timer(1).timeout
	print("GO TIME")
	Transitioned.emit(self, "GWander")

extends Area2D

signal leavingLevel
var isLocked : bool = true

func _on_body_entered(_body):
	leavingLevel.emit()
	var lockNumb = randi() % 3
	if lockNumb == 2 :
		isLocked = true
		print("locked")

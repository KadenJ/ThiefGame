extends Area2D

signal leavingLevel

func _on_body_entered(_body):
	leavingLevel.emit()

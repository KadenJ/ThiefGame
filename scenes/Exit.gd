extends Area2D

signal leavingLevel
@export var isLocked : bool

func _ready() -> void:
	var lockNumb = randi() % 3
	if lockNumb == 2:
		isLocked = true
		print("locked")

func _on_body_entered(_body):
	if isLocked == false:
		leavingLevel.emit()
	else: print("its locked")

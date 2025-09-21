extends Area2D

signal leavingLevel
signal doneLocking
@export var isLocked : bool

func _ready() -> void:
	var lockNumb = randi() % 3
	if lockNumb == 2:
		isLocked = true
	doneLocking.emit()

func _on_body_entered(_body):
	if isLocked == false:
		leavingLevel.emit()

extends Area2D

signal leavingLevel
signal doneLocking
@export var isLocked : bool
@onready var lockAudio: AudioStreamPlayer = $AudioStreamPlayer
@onready var unlockAudio: AudioStreamPlayer = $AudioStreamPlayer2


func _ready() -> void:
	var lockNumb = randi() % 3
	if lockNumb == 2:
		isLocked = true
		lockAudio.play()
	doneLocking.emit()
	
	

func _on_body_entered(_body):
	if isLocked == false:
		leavingLevel.emit()

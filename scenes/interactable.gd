class_name Interactable
extends Area2D

@export var timeToCollect : int

func _ready() -> void:
	complete.connect($Node.action)
	$GPUParticles2D.emitting = true
	

var completed = false #player checks if true
signal complete #emits for selectedInteractable

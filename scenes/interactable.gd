class_name Interactable
extends Area2D

@export var timeToCollect : int

func _ready() -> void:
	var interactableScript = DirAccess.open("res://interactableScripts/")
	var listedInteractables = []
	
	for i in interactableScript.get_files():
		if i.ends_with(".gd"):
			listedInteractables.append(i)
	print(listedInteractables)
	var selectedInteractable
	selectedInteractable = ResourceLoader.load("res://interactableScripts/" + listedInteractables[0]) #randi() % len(listedInteractables)
	print(selectedInteractable)
	
	
	if selectedInteractable:
		$Node.set_script(selectedInteractable)
		complete.connect($Node.action)
	else: printerr("no interactable")
	
	

var completed = false #player checks if true
signal complete #emits for selectedInteractable

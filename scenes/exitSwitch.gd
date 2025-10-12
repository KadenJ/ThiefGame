extends Node

signal unlocked

func _on_switch_collected() -> void:
	var door = get_parent().get_parent()
	door.isLocked = false
	print("unlocked")
	
	get_parent().player.unlocked()
	door.unlockAudio.play()

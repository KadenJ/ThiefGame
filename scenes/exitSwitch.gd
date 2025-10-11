extends Node

signal unlocked
func _on_switch_collected() -> void:
	var door = get_parent().get_parent()
	door.isLocked = false
	emit_signal("unlocked")
	print("unlocked")

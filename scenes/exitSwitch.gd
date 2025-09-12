extends Node


func _on_switch_collected() -> void:
	get_parent().get_parent().isLocked = false
	print("unlocked")

extends Node

func _on_area_2d_complete() -> void:
	print("safe cracked")
	get_parent().get_child(0).disabled = true

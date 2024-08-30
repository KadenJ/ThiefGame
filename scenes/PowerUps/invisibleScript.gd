extends Node2D

var player

func _on_power_up_collected():
	player = $"..".player
	
	player.set_collision_layer_value(4, false)
	player.set_modulate("ffffff5a")


func _on_power_up_worn_off():
	player.set_collision_layer_value(4, true)
	player.set_modulate("ffffff")

extends Control

func _ready():
	timer.connect("timeout", lightningHide)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Playable/world.tscn")


func _on_quit_pressed():
	get_tree().quit()

@onready var lightning = $images/lightning
@onready var timer = $images/lightning/Timer

func _on_timer_timeout():
	lightning.show()
	timer.start()
	

func lightningHide():
	lightning.hide()

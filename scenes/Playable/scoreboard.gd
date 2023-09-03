extends Control

@onready var label = $Panel/Label
@onready var label_2 = $Panel/Label2
@onready var label_3 = $Panel/Label3
@onready var label_4 = $Panel/Label4
#set_text(str(score).pad_zeros(5))
# Called when the node enters the scene tree for the first time.
func _ready():
	SaveLoad.loadScore()
	label.set_text(str(SaveLoad.scoreList[0]).pad_zeros(5))
	label_2.set_text(str(SaveLoad.scoreList[1]).pad_zeros(5))
	label_3.set_text(str(SaveLoad.scoreList[2]).pad_zeros(5))
	label_4.set_text(str(SaveLoad.scoreList[3]).pad_zeros(5))



func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Playable/menu.tscn")

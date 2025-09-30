extends Node2D

@export var score = 0

func _ready() -> void:
	Events.treasureStolen.connect(addScore)
	Events.TreasureGathered.connect(allTresGathered)
	$interactables/Exit.leavingLevel.connect(nextLevel)

func addScore():
	score += 100
	$CanvasLayer/Score/Label.set_text(str(score).pad_zeros(5))
	$CanvasLayer/Score.get_child(1).addScoreEffect(100)

func nextLevel():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Playable/world.tscn")
	print("tutorial Complete")

func allTresGathered():
	$CanvasLayer/treasurePrompt.show()
	get_tree().create_timer(3).timeout.connect($CanvasLayer/treasurePrompt.hide)

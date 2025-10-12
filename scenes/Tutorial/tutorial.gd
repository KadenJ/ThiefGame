extends Node2D

@export var score = 0

func _ready() -> void:
	Events.treasureStolen.connect(addScore)
	Events.TreasureGathered.connect(allTresGathered)
	$interactables/Exit.leavingLevel.connect(nextLevel)
	$interactables/Exit.isLocked = true
	$interactables/Exit.lockAudio.play()
	var player = get_tree().get_first_node_in_group("Player")
	player.soundsLocked()
	

func addScore():
	score += 100
	$CanvasLayer/Score/Label.set_text(str(score).pad_zeros(5))
	$CanvasLayer/Score.get_child(1).addScoreEffect(100)

func nextLevel():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Playable/world.tscn")

func allTresGathered():
	$CanvasLayer/treasurePrompt.show()
	get_tree().create_timer(3).timeout.connect($CanvasLayer/treasurePrompt.hide)


func _on_switch_collected() -> void:
	$"Layer0/5".hide()
	$"Layer0/4".text = "There's the stairs,\nlets get moving"

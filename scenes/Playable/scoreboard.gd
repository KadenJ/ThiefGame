extends Control
@onready var SCORES = $scores


func _ready():
	Scores.gotLeaderboard.connect(makeLeaderboard)
	Scores._get_leaderboards()
	

func makeLeaderboard():
	var scoreCount = 0
	for i in $scores.get_children():
		i.set_text(str(Scores.topScores[scoreCount]).pad_zeros(5))
		scoreCount+=1
	$boardCover.visible = false
	$Button.grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Playable/menu.tscn")


func _on_refresh_pressed():
	$boardCover.visible = true
	Scores._get_leaderboards()

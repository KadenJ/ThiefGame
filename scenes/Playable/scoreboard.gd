extends Control
@onready var SCORES = $scores


func _ready():
	print(Scores.online)
	Scores.gotLeaderboard.connect(makeLeaderboard)
	if Scores.online == false:
		makeLeaderboard()
	else:
		$offlineScores.visible = false
		Scores._get_leaderboards()
	

func makeLeaderboard():
	var scoreCount = 0
	if Scores.online:
		for i in SCORES.get_children():
			print(Scores.online)
			i.set_text(str(int(Scores.OnlineTopScores[scoreCount])).pad_zeros(5))
			scoreCount+=1
	else:
		for i in SCORES.get_children():
			Scores.loadScores()
			Scores.offlineTopScores.sort()
			Scores.offlineTopScores.reverse()
			i.set_text(str(int(Scores.offlineTopScores[scoreCount])).pad_zeros(5))
			scoreCount+=1
	$boardCover.visible = false
	$Button.grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Playable/menu.tscn")


func _on_refresh_pressed():
	if Scores.online:
		$boardCover.visible = true
		Scores._get_leaderboards()
	else:
		$boardCover.visible = true
		await get_tree().create_timer(1).timeout
		makeLeaderboard()
		

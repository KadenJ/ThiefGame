extends Control
@onready var SCORES = $scores


func _ready():
	print(Scores.online)
	Scores.gotLeaderboard.connect(makeLeaderboard)
	$CheckButton.button_pressed = !Scores.online
	if !Scores.online: #offline
		makeLeaderboard()
	else:
		#$offlineScores.visible = false
		Scores._get_leaderboards()
	


func makeLeaderboard():
	$offlineScores.show()
	var scoreCount = 0
	
	if Scores.online == true:
		for i in SCORES.get_children():
			i.set_text(str(int(Scores.OnlineTopScores[scoreCount])).pad_zeros(5))
			scoreCount+=1
			$offlineScores.hide()
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
	refresh()
	

func refresh():
	if Scores.online == true:
		$boardCover.visible = true
		Scores._get_leaderboards()
	else:
		$boardCover.visible = true
		await get_tree().create_timer(1).timeout
		makeLeaderboard()
		

func _on_online_offline_pressed() -> void:
	Scores.online = !Scores.online
	$CheckButton.button_pressed = !Scores.online
	refresh()

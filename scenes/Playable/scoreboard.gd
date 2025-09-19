extends Control
@onready var SCORES = $scores

var boardType : bool #false = offline

func _ready():
	print(Scores.online)
	Scores.gotLeaderboard.connect(makeLeaderboard)
	boardType = Scores.online
	$CheckButton.button_pressed = !boardType
	if boardType == false: #offline
		makeLeaderboard()
	else:
		#$offlineScores.visible = false
		Scores._get_leaderboards()
	


func makeLeaderboard():
	$offlineScores.show()
	var scoreCount = 0
	
	if boardType:
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
	if boardType:
		$boardCover.visible = true
		Scores._get_leaderboards()
	else:
		$boardCover.visible = true
		await get_tree().create_timer(1).timeout
		makeLeaderboard()
		

func _on_online_offline_pressed() -> void:
	if Scores.online:
		$CheckButton.button_pressed = boardType
		boardType = !boardType
		refresh()

extends Node

var OnlineTopScores = [1, 2, 3, 4, 5, 6 , 7]
var online = false

# Use this game API key if you want to test with a functioning leaderboard
# leaderboard key or game api not working on live
var game_API_key = "prod_315f351de7474f4b92dd307c55825de5"
var development_mode = false
var leaderboard_key = "Live"
var session_token = ""
var player_identifier = ""
#var score = 0


signal toggleWifi
signal gotLeaderboard

func _ready():
	loadScores()


func _authentication_request():
	# Check if a player session exists
	@warning_ignore("unused_variable")
	var player_session_exists = false
	var file = FileAccess.open("user://LootLocker.data", FileAccess.READ)
	if file != null:
		player_identifier = file.get_as_text()
		#print("player ID="+player_identifier)
		file.close()
 
	if player_identifier != null and player_identifier.length() > 1:
		#print("player session exists, id="+player_identifier)
		player_session_exists = true
	if(player_identifier.length() > 1):
		player_session_exists = true
		
	
	var guestLoginResponse = await LL_Authentication.GuestSession.new(player_identifier).send()
	if(!guestLoginResponse.success):
		online = false
		printerr("Guest login failed with reason: ")
		toggleWifi.emit()
		return
		
	print("Guest user was successfully signed in to LootLocker")

	online = true
	toggleWifi.emit()
	



func _get_leaderboards():
	#leaderboard needs to load scores before writing label
	
	var count : int = 6;

	var response = await LL_Leaderboards.GetScoreList.new(leaderboard_key, count).send()
	if(!response.success) :
		# Request failed, handle errors
		pass
	else:
	# Request succeeded, use response as applicable in your game logic
		var top = []
		for item in response['items']:
			top.append(item["score"])
		OnlineTopScores.clear()
		OnlineTopScores.append_array(top)
		gotLeaderboard.emit()
	print(OnlineTopScores)
	




#bad request on upload
func _upload_score(score: int):
	#can't be same member ID
	
	var response = await LL_Leaderboards.SubmitScore.new(leaderboard_key, score, player_identifier).send()
	if(!response.success) :
	# Request failed, handle errors
		pass
	else:
	# Request succeeded, use response as applicable in your game logic
		print(response)
	


#offline#########################################################################################
var offlineTopScores = [1,2,3,4,5,6]
#open offline score json
#load scores to offlineTopScores

func loadScores():
	var file = FileAccess.open("res://offlineScores.json", FileAccess.READ)
	var jsonScores = file.get_as_text()
	#var json = JSON.new()
	offlineTopScores = JSON.parse_string(jsonScores)
	
	file.close()

func saveScores():
	#if score > offlineTopScores[i]: drop lowest, append score
	var file = FileAccess.open("res://offlineScores.json",FileAccess.WRITE)
	#just change offlineTopScores then run saveScores()
	var scoreToSave = JSON.stringify(offlineTopScores)
	
	file.store_string(scoreToSave)
	
	file.close()

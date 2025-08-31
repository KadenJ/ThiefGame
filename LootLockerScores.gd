extends Node

var OnlineTopScores = [1, 2, 3, 4, 5, 6 , 7]
var online = false

# Use this game API key if you want to test with a functioning leaderboard
# leaderboard key or game api not working on live
var game_API_key = "prod_315f351de7474f4b92dd307c55825de5"
var development_mode = false
var leaderboard_key = "Live"
var session_token = ""
var score = 0

# HTTP Request node can only handle one call per node
var auth_http = HTTPRequest.new()
var leaderboard_http = HTTPRequest.new()
var submit_score_http = HTTPRequest.new()

func _ready():
	_authentication_request()
	loadScores()


func _authentication_request():
	# Check if a player session exists
	var player_session_exists = false
	var player_identifier : String
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
		
	## Convert data to json string:
	var data = { "game_key": game_API_key, "game_version": "0.0.0.1", "development_mode": true }
	
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	
	# Create a HTTPRequest node for authentication
	auth_http = HTTPRequest.new()
	add_child(auth_http)
	auth_http.request_completed.connect(_on_authentication_request_completed)
	# Send request
	auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))


func _on_authentication_request_completed(result, response_code, headers, body):
	online = true
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Save the player_identifier to file
	var file = FileAccess.open("user://LootLocker.data", FileAccess.WRITE)
	file.store_string(json.get_data().player_identifier)
	file.close()
	
	# Save session_token to memory
	session_token = json.get_data().session_token
	
	
	# Clear node
	auth_http.queue_free()
	# Get leaderboards
	#_get_leaderboards()
	


func _get_leaderboards():
	#leaderboard needs to load scores before writing label
	#print("Getting leaderboards")
	var url = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/list?count=10"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	leaderboard_http = HTTPRequest.new()
	add_child(leaderboard_http)
	leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
	
	# Send request
	leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")

signal gotLeaderboard
func _on_leaderboard_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	
	
	var counter = 0
	print(json.get_data())
	for n in json.get_data().items.size():
		OnlineTopScores[counter] = json.get_data().items[n].score
		counter +=1
		if counter == len(OnlineTopScores):
			OnlineTopScores.sort()
			OnlineTopScores.reverse()
			break
		gotLeaderboard.emit()
	Events.gotScores.emit()
	# Print the formatted leaderboard to the console
	#print(OnlineTopScores)
	
	# Clear node
	#leaderboard_http.queue_free()

#bad request on upload
func _upload_score(score: int):
	#can't be same member ID
	var data = { "member_id": str(randi_range(0,10000)).pad_zeros(5), "score": str(score)}
	var url : String = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	submit_score_http.request_completed.connect(_on_upload_score_request_completed)
	# Send request
	submit_score_http.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
	


func _on_upload_score_request_completed(result, response_code, headers, body) :
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	
	#print(response_code)
	# Clear node
	submit_score_http.queue_free()

#offline#########################################################################################
var offlineTopScores = [1,2,3,4,5,6]
#open offline score json
#load scores to offlineTopScores

func loadScores():
	var file = FileAccess.open("res://offlineScores.json", FileAccess.READ)
	var jsonScores = file.get_as_text()
	var json = JSON.new()
	offlineTopScores = json.parse_string(jsonScores)
	
	file.close()

func saveScores():
	#if score > offlineTopScores[i]: drop lowest, append score
	var file = FileAccess.open("res://offlineScores.json",FileAccess.WRITE)
	#just change offlineTopScores then run saveScores()
	var scoreToSave = JSON.stringify(offlineTopScores)
	
	file.store_string(scoreToSave)
	
	file.close()

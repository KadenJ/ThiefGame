extends Node2D

#soft swing music or classic heist music(diamond jack type as example)

const Player = preload("res://scenes/Player.tscn")
const Exit = preload("res://scenes/Exit.tscn")
const exitSwitch = preload("res://scenes/PowerUps/switch.tscn")
const Treasure = preload("res://scenes/treasure.tscn")
const Guard = preload("res://scenes/guard.tscn")
const Dog = preload("res://scenes/dog.tscn")

var borders = Rect2(1,1,35,19) #(space from edge,space from edge,width,height)

var score = 0
var floorNumber = 0

@onready var tileMap = $Layer0#$TileMap
@onready var treasure_prompt = $CanvasLayer/treasurePrompt
@onready var loading_screen = $CanvasLayer/loadingScreen
@onready var loading_timer = $CanvasLayer/loadingScreen/loadingTimer
@onready var scoreLabel = $CanvasLayer/Score/Label
@onready var game_over_screen = $CanvasLayer/GameOverScreen

@export var size = 250

var treasureList = []
var guardList = []

var level = Events.level

func _ready():
	level = 0
	Events.TreasureGathered.connect(showTreasurePrompt)
	Events.treasureStolen.connect(collectTreasure)
	Events.guardCaught.connect(GameOver)
	loading_timer.connect("timeout", hideLoadScreen)
	scoreLabel.set_text(str(score).pad_zeros(5))
	#game_over_screen.get_child(3).set_text(str(SaveLoad.highestRecord).pad_zeros(5))
	
	generateLevel()

var powerUp = load("res://scenes/PowerUps/InvisPowerUp.tscn")
func generateLevel():
	level += 1
	#@warning_ignore("integer_division")
	var walker = Walker.new(Vector2(17,9), borders) #Vector2(36/2, 20/2)
	var map = walker.walk(size)#size of room, amount of total steps taken
	
	var player = Player.instantiate()
	call_deferred("add_child", player)
	player.position = map.front()*32
	
	var powerUpT = powerUp.instantiate()
	powerUpT.position = walker.rooms[randi() % len(walker.rooms)].position*32
	call_deferred("add_child", powerUpT)
	
	var exit = Exit.instantiate()
	call_deferred("add_child", exit)
	exit.position = walker.getEndRoom().position*32
	if exit.isLocked == true:
		var es = exitSwitch.instantiate()
		es.position = walker.rooms[4].position*32
		exit.call_deferred("add_child", es)
	
	exit.leavingLevel.connect(reloadLevel)
	
	
	#spawns treasures
	for room in walker.rooms:
		var roomEval = randi()% 10
		if roomEval == 1:
			var treasure = Treasure.instantiate()
			treasure.position = room.position*32
			if treasure.position == exit.position:
				pass
			else:
				call_deferred("add_child", treasure)
				room.hasTreasure = true
				treasureList.append(treasure.position)
	
	#spawns enemies
	var maxGuardCount = 2 + floorNumber #max guards per floor
	var maxDogSquadCount = 0
	for room in walker.rooms:
		var roomEval = randi()% 12
		if roomEval == 3 && guardList.size() <= maxGuardCount:
			var guard = Guard.instantiate()
			
			#if guard in room pass
			if guardList.count(room.position*32) < 1:
				guard.position = room.position*32
				if guard.position.distance_to(player.position) > abs(20):
					call_deferred("add_child", guard)
					guardList.append(guard.position)
					
		elif roomEval == 4 && level >= 3 && guardList.size() <= maxGuardCount && maxDogSquadCount < 2:
			var dog = Dog.instantiate()
			var guard = Guard.instantiate()
			if guardList.count(room.position*32) < 1:
				maxDogSquadCount += 1
				dog.position = room.position*32
				guard.position = room.position*32
				if dog.position.distance_to(player.position) > abs(10):
					call_deferred("add_child", dog)
					call_deferred("add_child", guard)
					guardList.append(guard.position)
					guardList.append(dog.position)
	
	#changes floor tiles
	walker.queue_free()
	for location in map:
		tileMap.set_cell(location, 1, Vector2i(4,4))
		


func reloadLevel():
	var children = get_children()
	giveScore(200)
	floorNumber += 1
	#place black screen with small animation
	loading_screen.show()
	loading_timer.start()
	if Events.isMuted == false:
		$CanvasLayer/loadingScreen/stairAudio.play()
	#queue_free all nodes thats not tilemap and treasurePrompt
	treasureList.clear()
	guardList.clear()
	var count = 0
	for child in children:
		count += 1
		if count > 3:
			child.queue_free()
	treasure_prompt.hide()
	#repavement
	for row in 20:
		for i in 36:
			tileMap.set_cell(Vector2i(i,row), 1, Vector2i(0,0))
		

func showTreasurePrompt():
	giveScore(500)
	treasure_prompt.show()
	$CanvasLayer/treasurePrompt/Timer.start()


func hideLoadScreen():
	
	generateLevel()
	print("new level gen")
	loading_screen.hide()

func giveScore(points):
	score += points
	scoreLabel.set_text(str(score).pad_zeros(5))

func collectTreasure():
	giveScore(100)
	if Events.isMuted == false:
		$CanvasLayer/treasureAudio.play()

func GameOver():
	var children = get_children()
	var count = 0
	for child in children:
		count += 1
		if count > 3:
			child.queue_free()
	
	uploadPlayerScore()
	game_over_screen.get_child(3).set_text(str(score).pad_zeros(5))
	game_over_screen.show()
	$CanvasLayer/GameOverScreen/retry.grab_focus()
	
func uploadPlayerScore():
	if Scores.online == true:
		Scores._get_leaderboards()
		if score > Scores.OnlineTopScores[0]:
			game_over_screen.get_child(4).show()
			Scores._upload_score(score)
		elif score > Scores.OnlineTopScores.back():
			game_over_screen.get_child(5).show()
			Scores._upload_score(score)
	else:
		#offline Score
		var offlineScores = Scores.offlineTopScores
		if score > Scores.offlineTopScores[0]:
			game_over_screen.get_child(4).show()
			offlineScores.pop_back()
			offlineScores.append(score)
		elif score > Scores.offlineTopScores.back():
			game_over_screen.get_child(5).show()
			offlineScores.pop_back()
			offlineScores.append(score)
		Scores.saveScores()
		print(offlineScores)
		

func _on_timer_timeout():
	treasure_prompt.hide()

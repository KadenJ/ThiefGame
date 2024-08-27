extends Node2D

#soft swing music or classic heist music(diamond jack type as example)

const Player = preload("res://scenes/Player.tscn")
const Exit = preload("res://scenes/Exit.tscn")
const Treasure = preload("res://scenes/treasure.tscn")
const Guard = preload("res://scenes/guard.tscn")
const Dog = preload("res://scenes/dog.tscn")

var borders = Rect2(1,1,35,19) #(space from edge,space from edge,width,height)

var score = 0
var floorNumber = 0

@onready var tileMap = $TileMap
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

var powerUp = load("res://scenes/invisPowerUp.tscn")
func generateLevel():
	level += 1
	#@warning_ignore("integer_division")
	var walker = Walker.new(Vector2(17,9), borders) #Vector2(36/2, 20/2)
	var map = walker.walk(size)#size of room, amount of total steps taken
	
	var player = Player.instantiate()
	call_deferred("add_child",player)
	player.position = map.front()*32
	
	var powerUpT = powerUp.instantiate()
	powerUpT.position = walker.rooms[randi() % len(walker.rooms)].position*32
	call_deferred("add_child", powerUpT)
	
	var exit = Exit.instantiate()
	call_deferred("add_child",exit)
	exit.position = walker.getEndRoom().position*32
	exit.leavingLevel.connect(reloadLevel)
	
	#spawns treasures
	for room in walker.rooms:
		var roomEval = randi()% 10
		if roomEval == 1:
			var treasure = Treasure.instantiate()
			call_deferred("add_child",treasure)
			treasure.position = room.position*32
			room.hasTreasure = true
			treasureList.append(treasure.position)
			if treasure.position == exit.position:
				treasure.queue_free()
				
	#spawns enemies
	for room in walker.rooms:
		var roomEval = randi()% 12
		if roomEval == 3:
			var guard = Guard.instantiate()
			call_deferred("add_child",guard)
			if guardList.count(room.position*32) == 1:
				guard.queue_free()
			else:
				guard.position = room.position*32
				guardList.append(guard.position)
				
			#checks for treasure on pos
			for i in treasureList:
				if guard.position == i:
					guard.queue_free()
			if guard.position == exit.position || guard.position.distance_to(player.position) < abs(20):
				guard.queue_free()
		elif roomEval == 4 && level >= 5:
			var dog = Dog.instantiate()
			call_deferred("add_child",dog)
			if guardList.count(room.position*32) == 1:
				dog.queue_free()
			else:
				dog.position = room.position*32
				guardList.append(dog.position)
			#checks for treasure on pos
			for i in treasureList:
				if dog.position == i:
					dog.queue_free()
			if dog.position == exit.position || dog.position.distance_to(player.position) < abs(10):
				dog.queue_free()
			
	#changes floor tiles
	walker.queue_free()
	for location in map:
		tileMap.set_cell(0, location, 1, Vector2i(4,4))
		


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
			tileMap.set_cell(0,Vector2i(i,row), 1, Vector2i(0,0))
		
	#generateLevel()

func showTreasurePrompt():
	giveScore(500)
	treasure_prompt.show()
	$CanvasLayer/treasurePrompt/Timer.start()


func hideLoadScreen():
	loading_screen.hide()
	loading_timer.stop()
	generateLevel()

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
	
	if score > Scores.topScores[0]:
		game_over_screen.get_child(4).show()
		Scores._upload_score(score)
	elif score > Scores.topScores[len(Scores.topScores)-2]:
		game_over_screen.get_child(5).show()
		Scores._upload_score(score)
	game_over_screen.get_child(3).set_text(str(score).pad_zeros(5))
	game_over_screen.show()
	$CanvasLayer/GameOverScreen/retry.grab_focus()
	


func _on_timer_timeout():
	treasure_prompt.hide()

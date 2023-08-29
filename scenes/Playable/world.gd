extends Node2D

#soft swing music or classic heist music(diamond jack type as example)

const Player = preload("res://scenes/Player.tscn")
const Exit = preload("res://scenes/Exit.tscn")
const Treasure = preload("res://scenes/treasure.tscn")
const Guard = preload("res://scenes/guard.tscn")

var borders = Rect2(1,1,35,19) #(space from edge,space from edge,width,height)
var score = 0

@onready var tileMap = $TileMap
@onready var treasure_prompt = $CanvasLayer/treasurePrompt
@onready var loading_screen = $CanvasLayer/loadingScreen
@onready var loading_timer = $CanvasLayer/loadingScreen/loadingTimer
@onready var _score = $CanvasLayer/Score/Label

@export var size = 250

var treasureList = []
#var TList = []
var guardList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize()
	Events.TreasureGathered.connect(showTreasurePrompt)
	Events.treasureStolen.connect(giveScore.bind(100))
	loading_timer.connect("timeout", hideLoadScreen)
	_score.set_text(str(score).pad_zeros(5))
	
	
	generateLevel()

func generateLevel():
	#@warning_ignore("integer_division")
	var walker = Walker.new(Vector2(17,9), borders) #Vector2(36/2, 20/2)
	var map = walker.walk(size)#size of room, amount of total steps taken
	
	var player = Player.instantiate()
	#add_child(player)
	call_deferred("add_child",player)
	player.position = map.front()*32
	
	var exit = Exit.instantiate()
	#add_child(exit)
	call_deferred("add_child",exit)
	exit.position = walker.getEndRoom().position*32
	exit.leavingLevel.connect(reloadLevel)
	
	#spawns treasures
	for room in walker.rooms:
		var roomEval = randi()% 10
		if roomEval == 1:
			var treasure = Treasure.instantiate()
			#add_child(treasure)
			call_deferred("add_child",treasure)
			treasure.position = room.position*32
			room.hasTreasure = true
			treasureList.append(treasure.position)
			#TList.append(Area2D)
			if treasure.position == exit.position:
				treasure.queue_free()
	#spawns guards
	for room in walker.rooms:
		var roomEval = randi()% 10
		if roomEval == 3:
			var guard = Guard.instantiate()
			#add_child(guard)
			call_deferred("add_child",guard)
			#checks for other guards
			if guardList.count(room.position*32) == 1:
				guard.queue_free()
			else:
				guard.position = room.position*32
				guardList.append(guard.position)
			#checks for treasure on pos
			for i in treasureList:
				if guard.position == i:
					#change to move 
					guard.queue_free()
			if guard.position == exit.position || guard.position.distance_to(player.position) < abs(10):
				guard.queue_free()
	#changes floor tiles
	walker.queue_free()
	for location in map:
		tileMap.set_cell(0, location, 1, Vector2i(4,4))
		


func reloadLevel():
	var children = get_children()
	giveScore(200)
	#place black screen with small animation
	loading_screen.show()
	loading_timer.start()
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

func _input(event):
	if event.is_action_pressed("levelControl"):
		reloadLevel()

func showTreasurePrompt():
	giveScore(500)
	treasure_prompt.show()

func hideLoadScreen():
	loading_screen.hide()
	loading_timer.stop()
	generateLevel()

func giveScore(points):
	score += points
	#show score on label
	_score.set_text(str(score).pad_zeros(5))
	print(score)

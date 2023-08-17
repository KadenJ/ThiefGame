extends Node2D

const Player = preload("res://scenes/Player.tscn")
const Exit = preload("res://scenes/Exit.tscn")
const Treasure = preload("res://scenes/treasure.tscn")
const Guard = preload("res://scenes/guard.tscn")

var borders = Rect2(1,1,35,19) #(space from edge,space from edge,width,height)
@onready var tileMap = $TileMap
@onready var treasure_prompt = $CanvasLayer/treasurePrompt

@export var size = 250

var treasureList = []
var guardList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize()
	Events.TreasureGathered.connect(showTreasurePrompt)
	generateLevel()

func generateLevel():
	@warning_ignore("integer_division")
	var walker = Walker.new(Vector2(17,9), borders) #Vector2(36/2, 20/2)
	var map = walker.walk(size)#size of room, amount of total steps taken
	
	var player = Player.instantiate()
	add_child(player)
	player.position = map.front()*32
	
	var exit = Exit.instantiate()
	add_child(exit)
	exit.position = walker.getEndRoom().position*32
	exit.leavingLevel.connect(reloadLevel)
	
	#spawns treasures and guards
	for room in walker.rooms:
		var roomEval = randi()% 10
		if roomEval == 1:
			var treasure = Treasure.instantiate()
			add_child(treasure)
			treasure.position = room.position*32
			room.hasTreasure = true
			treasureList.append(treasure.position)
			if treasure.position == exit.position:
				treasure.queue_free()
	for room in walker.rooms:
		var roomEval = randi()% 10
		if roomEval == 3 || roomEval == 4:
			var guard = Guard.instantiate()
			add_child(guard)
			guard.position = room.position*32
			for i in treasureList:
				if guard.position == i:
					#change to move 
					guard.queue_free()
			if guard.position == exit.position || guard.position.distance_to(player.position) < abs(10):
				guard.queue_free()
				
	print(treasureList)
	#changes floor tiles
	walker.queue_free()
	for location in map:
		tileMap.set_cell(0, location, 1, Vector2i(4,4))

func reloadLevel():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reloadLevel()

func showTreasurePrompt():
	treasure_prompt.show()


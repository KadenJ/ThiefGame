extends Node2D

const Player = preload("res://scenes/Player.tscn")
const Exit = preload("res://scenes/Exit.tscn")
const Treasure = preload("res://scenes/treasure.tscn")

var borders = Rect2(1,1,35,19) #(space from edge,space from edge,width,height)
@onready var tileMap = $TileMap
@export var size = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize()
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
	
	for room in walker.rooms:
		print(room)
		var roomEval = randi()% 10
		if roomEval == 1:
			var treasure = Treasure.instantiate()
			add_child(treasure)
			treasure.position = room.position*32
		elif roomEval == 3:
			pass#spawn guard
	
	walker.queue_free()
	for location in map:
		tileMap.erase_cell(0, location)
		#tileMap.set_cellv(location,-1)
	#tileMap.update_bitmask_region(borders.position, borders.end)

func reloadLevel():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reloadLevel()
		
		

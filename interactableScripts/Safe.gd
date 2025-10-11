extends Node

var treasure = preload("res://scenes/treasure.tscn")

var coveredTiles = []
var treasureSpread = 7

func action():
	print("safe cracked")
	get_parent().get_child(0).disabled = true
	$"../Sprite2D".frame = 1
	$"../GPUParticles2D".emitting = true
			
	var tileMap : TileMapLayer = get_tree().get_first_node_in_group("TileMap")
	var start = tileMap.local_to_map(get_parent().global_position)
	coveredTiles.append(start)
	for i in treasureSpread:
		var dir = Vector2i(randi_range(-1,1),randi_range(-1,1))
		var toBeAdded = coveredTiles.back() + dir
		if toBeAdded.x < toBeAdded.x+5 and toBeAdded.y < toBeAdded.y+5:
			if tileMap.get_cell_atlas_coords(toBeAdded) == Vector2i(4,4):
				coveredTiles.append(toBeAdded)
			else: print("invalid")
		else: coveredTiles.append(start + (start - coveredTiles[2]))
		
	for i in coveredTiles:
		var T = treasure.instantiate()
		T.position = (tileMap.map_to_local(i))
		add_child(T)

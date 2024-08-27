extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
const Treasure = preload("res://scenes/treasure.tscn")

var position =Vector2.ZERO
var direction = Vector2.RIGHT
var borders =Rect2()
var stepHistory=[]
var stepsSinceTurn=0
var spawnCreated = false
var rooms = []

var forceChange = 6

func _init(startingPosition, newBorders):
	assert(newBorders.has_point(startingPosition))
	position=startingPosition
	stepHistory.append(position)
	borders=newBorders
	
	
#will walk certain amount of steps then return step history
func walk(steps):
	placeRoom(position)
	for _step in steps:
		if stepsSinceTurn >= forceChange: # if gone for more than forceChange steps
			changeDirection()
		
		if step():
			stepHistory.append(position)
		else: 
			changeDirection()
	return stepHistory

func step():
	var targetPosition = position+direction
	#if target position inside borders, take a step else don't
	if borders.has_point(targetPosition):
		stepsSinceTurn +=1
		position = targetPosition
		return true
	else:
		return false

func changeDirection():
	placeRoom(position)
	stepsSinceTurn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction) #removes current direction going from list of directions (wont go in same direction)
	directions.shuffle()
	direction = directions.pop_front() #wont check same direction multiple times when checking if inside border
	while !borders.has_point(position+direction):
		direction = directions.pop_front()


func createRoom(_position, size):
	var hasTreasure = false
	return{position = _position, size = size, hasTreasure = hasTreasure}

func placeRoom(position):
	var size = Vector2(randi()%4+2, randi()%4+2)
	var topLeftCorner=(position-size/2).ceil()
	rooms.append(createRoom(position,size))
	for y in size.y:
		for x in size.x:
			var newStep= topLeftCorner+Vector2(x,y)
			if borders.has_point(newStep):
				stepHistory.append(newStep)

func getEndRoom():
	var endRoom =rooms.pop_front()
	var startingPosition = stepHistory.front()
	
	for room in rooms:
		if startingPosition.distance_to(room.position)>startingPosition.distance_to(endRoom.position):
			endRoom=room
	return endRoom

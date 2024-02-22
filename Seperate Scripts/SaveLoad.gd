extends Node

const SAVEFILE = "user://savefile.save"

#var highestRecord = 0
var scoreList = [15000,7500,4500,1500]

func _ready():
	loadScore()
	

func saveScore():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)	
	for i in scoreList.size():
		file.store_32(scoreList[i])
	#file.store_32(highestRecord)
	file = null
	

func loadScore():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ_WRITE)
	if FileAccess.file_exists(SAVEFILE):
		for i in scoreList.size():
			scoreList[i] = file.get_32()
		#highestRecord = file.get_32()

extends Node

const SAVEFILE = "user://savefile.save"

var highestRecord = 0

func _ready():
	loadScore()
	

func saveScore():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)	
	file.store_32(highestRecord)
	file = null
	

func loadScore():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ_WRITE)
	if FileAccess.file_exists(SAVEFILE):
		highestRecord = file.get_32()

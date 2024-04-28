extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	Events.treasureStolen.emit()
	queue_free()
	var treasures = get_tree().get_nodes_in_group("Treasures")
	if treasures.size() == 1:
		Events.TreasureGathered.emit()
		#print("all treasures collected")

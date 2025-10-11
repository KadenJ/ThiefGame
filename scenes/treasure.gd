extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(_body):
	Events.treasureStolen.emit()
	
	var treasures = get_tree().get_nodes_in_group("Treasures")
	if treasures.size() == 1: #if gathered at same time, doesn't emit
		Events.TreasureGathered.emit()
		#print("all treasures collected")
	set_deferred("monitoring", false)
	$CollisionShape2D/Sprite2D.hide()
	$GPUParticles2D.emitting = true
	delete()

func delete():
	await $GPUParticles2D.finished
	queue_free()

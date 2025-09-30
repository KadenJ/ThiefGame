extends Marker2D
var tween:Tween
@onready var  effectLabel = $effectLabel
func addScoreEffect(amt):
	if tween and tween.is_running():
		await create_tween().tween_interval(.3).finished
		#await tween.finished <---- gives slight delay 
		tween.kill()
	
	tween = get_tree().create_tween()
	effectLabel.set_text(str("+", amt))
	effectLabel.position = Vector2(0, 0) 
	effectLabel.modulate = Color.WHITE
	
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(effectLabel, "position", Vector2(0,-90), .4)
	tween.set_parallel()
	tween.tween_property(effectLabel, "modulate", Color.TRANSPARENT, .4)
	

extends Control

func _ready():
	$images/buttons/buttons/Play.grab_focus()
	timer.connect("timeout", lightningHide)
	if Events.loaded == false:
		Events.gotScores.connect(loadingFinished)
	else: $images/loading.visible = false


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Playable/world.tscn")


func _on_quit_pressed():
	get_tree().quit()

@onready var lightning = $images/lightning
@onready var timer = $images/lightning/Timer

func _on_timer_timeout():
	lightning.show()
	timer.start()
	

func lightningHide():
	lightning.hide()


func _on_score_board_pressed():
	get_tree().change_scene_to_file("res://scenes/Playable/scoreboard.tscn")


func _on_check_button_toggled(toggled_on):
	Events.isMuted = toggled_on
	BgMusic.playing = !Events.isMuted

func loadingFinished():
	$images/loading.visible = false
	Events.loaded = true

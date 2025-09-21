extends Control

func _ready():
	$images/buttons/buttons/Play.grab_focus()
	timer.connect("timeout", lightningHide)
	
	Scores.toggleWifi.connect(toggleOnline)
	$connection.button_pressed = Scores.online
	
	Scores._authentication_request()


#######################bg effects
@onready var lightning = $images/lightning
@onready var timer = $images/lightning/Timer

func _on_timer_timeout():
	print("light")
	lightning.show()
	timer.start()

func lightningHide():
	lightning.hide()
#######################

#######################Buttons
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Playable/tutorial.tscn")

func _on_score_board_pressed():
	get_tree().change_scene_to_file("res://scenes/Playable/scoreboard.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_mute_button_pressed() -> void: #touch to mute
	$CheckButton.button_pressed = Events.isMuted
	Events.isMuted = !Events.isMuted
	
	BgMusic.playing = !Events.isMuted

func _on_touch_screen_button_pressed() -> void: #touch button for wifi
	Scores._authentication_request()
	$connection/wifiLoading.visible = true

func toggleOnline(): #sets switch to online status
	$connection.button_pressed = Scores.online
	$connection/wifiLoading.visible = false
	$images/loading.hide()
#####################################

func loadingFinished():
	$images/loading.visible = false
	Events.loaded = true

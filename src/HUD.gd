extends CanvasLayer
signal start_game
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func reboot_life():
	$Vida/Heart1.visible = true;
	$Vida/Heart2.visible = true;
	$Vida/Heart3.visible = true;
	$Vida/Heart4.visible = false;
	$Vida/Heart5.visible = false;
	
func show_message(text):
    $MessageLabel.text = text
    $MessageLabel.show()
    $MessageTimer.start()
	
func show_game_over():
    show_message(tr("LOST"))
    yield($MessageTimer, "timeout")
    $StartButton.show()
    $MessageLabel.text = "NAME"
    $MessageLabel.show()
	
func update_score(score):
    $ScoreLabel.text = str(score)

func update_best(best):
	$Best.text = "Max: "+str(best)
	
func _on_StartButton_pressed():
    $StartButton.hide()
    emit_signal("start_game")

func _on_MessageTimer_timeout():
    $MessageLabel.hide()
    $Prepare.hide()
	
func _ready():
	$StartButton.text = tr("START")
	$MessageLabel.text = tr("NAME")
	$Prepare.text = tr("INST")
	reboot_life()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

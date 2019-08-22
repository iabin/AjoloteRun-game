extends Area2D
signal hit
signal fed
signal god_on
signal god_off
signal new_life

# var b = "textvar"
export (int) var speed  # How fast the player will move (pixels/sec).
var screensize  # Size of the game window.
var timer = 0.2
var godMode = false

func _ready():
	screensize = get_viewport_rect().size
	hide()
	# Called when the node is added to the scene for the first time.
	# Initialization here
func _input(event):
    var pre = position
    var velocity = Vector2() # The player's movement vector.
    if event is InputEventMouseMotion:
        position += event.relative
        velocity = event.relative
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    #else:
        #$AnimatedSprite.stop()
    #position += velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)

    if velocity.x != 0:
        $AnimatedSprite.play()
        $AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = false
        $AnimatedSprite.flip_h = velocity.x < 0
        if velocity.x < 0:
            $CollisionShape2D.rotation_degrees = -463.7
        else:
            $CollisionShape2D.rotation_degrees = 105

   
    

func randColor():
	$AnimatedSprite.modulate = Color(randf(),randf(),randf())
	
	
func _process(delta):
	if not godMode:
		return
	randColor()

func _on_Player_body_entered(body):
     # Player disappears after being hit.
    print(body.has_method("isPower"))
	
    if (body.has_method("isLife")):
        emit_signal("new_life")
        body.free()
        return
    if (body.has_method("isPower")):
        godMode = true
        $GodModeTimer.start()
        $PowerMusic.play()
        emit_signal("god_on")

    if (body.has_method("isFood") or godMode):
        emit_signal("fed") 
        body.free()
        return
    body.free()
    emit_signal("hit")
   
   
	
func die():
	$CollisionShape2D.disabled = true
	hide()

func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false


func _on_GodModeTimer_timeout():
	$PowerMusic.stop()
	emit_signal("god_off")
	godMode = false
	$GodModeTimer.stop()
	$AnimatedSprite.modulate = Color(1,1,1)
	pass # replace with function body

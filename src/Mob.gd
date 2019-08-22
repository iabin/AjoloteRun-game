extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.
var mob_types = ["vaso"]

func _ready():
	$AnimatedSprite.animation =  mob_types[randi() % mob_types.size()]
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func free():
	queue_free()
	
func _on_Visibility_screen_exited():
	queue_free()

extends RigidBody2D


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.
var food_types = ["strawberry","grape"]
func _ready():
	randomize()
	#$AnimatedSprite.animation =  food_types[randi() % food_types.size()]
	var food = food_types[randi() % food_types.size()]
	print(food)

	
	if (food == "strawberry"):
		$Grape.visible = false
		$Strawberry.visible = true
	if (food == "grape"):
		$Strawberry.visible = false
		$Grape.visible = true
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
	
func isFood():
	true

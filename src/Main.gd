extends Node

export (PackedScene) var Mob
export (PackedScene) var Food
export (PackedScene) var Power
export (PackedScene) var Life
var score
var velocidad = 1
var escenario = 21
var life = 3
# filename to store the data - note the path
var score_file = "user://highscore.txt"
var highscore = 0


func _ready():
	randomize()
	$Music.play()
	if (not load_score()):
		save_score()
		load_score()
	else:
		load_score()
	$HUD.update_best(highscore)

func _process(delta):
	#print(velocidad)
	velocidad += delta


func game_over():
    life-=1  
    if(life > 0):
        render_life()
        $Hurt.play()
        return
    if score > highscore :
        highscore = score
        save_score()
    $DeathSound.play()
    $HUD/Vida/Heart1.visible = false
    $Player.die()
    $ScoreTimer.stop()
    $FoodTimer.stop()
    $PowerTimer.stop()
    $MobTimer.stop()
    $LifeTimer.stop()
    $HUD.show_game_over()
    var mob = Mob.instance()
    for node in get_children():
        if (node.has_method("_on_Visibility_screen_exited")):
            node.free()



func render_life():
    if life == 5:
        $HUD/Vida/Heart5.visible = true
        $HUD/Vida/Heart4.visible = true
        $HUD/Vida/Heart3.visible = true
        $HUD/Vida/Heart2.visible = true
        return
    if life == 4:
        $HUD/Vida/Heart5.visible = false
        $HUD/Vida/Heart4.visible = true
        $HUD/Vida/Heart3.visible = true
        $HUD/Vida/Heart2.visible = true
        return
    if life == 3:
        $HUD/Vida/Heart5.visible = false
        $HUD/Vida/Heart4.visible = false
        $HUD/Vida/Heart3.visible = true
        $HUD/Vida/Heart2.visible = true
        return
    if life == 2:
        $HUD/Vida/Heart5.visible = false
        $HUD/Vida/Heart4.visible = false
        $HUD/Vida/Heart3.visible = false
        $HUD/Vida/Heart2.visible = true
        return
    if life == 1:
        $HUD/Vida/Heart5.visible = false
        $HUD/Vida/Heart4.visible = false
        $HUD/Vida/Heart3.visible = false
        $HUD/Vida/Heart2.visible = false
        return

func new_game():
    $MobTimer.wait_time = 0.6  
    $HUD.update_best(highscore)
    load_score()
    $HUD.reboot_life()
    life = 3
    velocidad = 1
    score = 0
    $Player.start($StartPosition.position)
    $HUD.update_score(score)
    $HUD.show_message(tr("GET_READY"))
    $StartTimer.start()
	
func _on_StartTimer_timeout():
    $MobTimer.start()
    $FoodTimer.start()
    $PowerTimer.start()
    $ScoreTimer.start()
    $LifeTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	escenario -= 1
	$HUD.update_score(score)
	"""
	print(escenario)
	if escenario == 0:
		escenario = 40
		$Background.visible = true
		$Background2.visible = false
	if escenario == 20:
		escenario = 20
		$Background.visible = false
		$Background2.visible = true 
    """
	
func _on_MobTimer_timeout():
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.set_offset(randi())
    # Create a Mob instance and add it to the scene.
    var mob = Mob.instance()
    add_child(mob)
    # Set the mob's direction perpendicular to the path direction.
    var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position
    # Add some randomness to the direction.
    direction = 0#rand_range(-PI / 4, PI / 4)
    var maximum = velocidad
    var percent = randf()

    # some coode
    if velocidad >100:
        $MobTimer.wait_time = 0.3
        maximum = 100;
        if (percent > 0.3):
            direction =  rand_range(-0.2,0.2)
    elif velocidad >50:
        $MobTimer.wait_time = 0.4
        if (percent > 0.3):
            direction =  rand_range(-0.15,0.15)
    elif velocidad > 20:
        $MobTimer.wait_time = 0.6   
        if (percent > 0.3):
            direction =  rand_range(-0.07,0.07)

    
    mob.rotation = direction
    # Choose the velocity.
    
    mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed)+maximum, 0).rotated(direction))

func _on_FoodTimer_timeout():
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.set_offset(randi())
    # Create a Mob instance and add it to the scene.
    var mob = Food.instance()
    add_child(mob)
    # Set the mob's direction perpendicular to the path direction.
    var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position
    # Add some randomness to the direction.
    direction = 0#rand_range(-PI / 4, PI / 4)
    mob.rotation = direction
    # Choose the velocity.
    mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))

func _on_Player_fed():
	score += 3
	$FoodSound.play()
	$HUD.update_score(score)

func _on_PowerTimer_timeout():
    if randf() < 0.65:
        return
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.set_offset(randi())
    # Create a Mob instance and add it to the scene.
    var mob = Power.instance()
    add_child(mob)
    # Set the mob's direction perpendicular to the path direction.
    var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position
    # Add some randomness to the direction.
    direction = 0#rand_range(-PI / 4, PI / 4)
    mob.rotation = direction
    # Choose the velocity.
    mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))

func _on_Player_god_on():
	$Music.volume_db = -40
	$FoodSound.volume_db = -20

func _on_Player_god_off():
	$Music.volume_db = 0
	$FoodSound.volume_db = 0




# call this at the beginning of your game.
# Tests to see if the file exists and loads the contents if it does
func load_score():
    var f = File.new()
    if f.file_exists(score_file):
        f.open(score_file, File.READ)
        var content = f.get_as_text()
        highscore = int(content)
        f.close()
        return true
    return false
 

# call this at game end to store a new highscore
func save_score():
    var f = File.new()
    f.open(score_file, File.WRITE)
    f.store_string(str(highscore))
    f.close()


func _on_Player_new_life():
	if(life>4):
		score += 3
		return
	$Life_up.play()
	score += 3
	life+=1
	$HUD.update_score(score)
	render_life()


func _on_LifeTimer_timeout():

    if(life == 1):
        if randf() < 0.65:
            return
    if(life == 2):
        if randf() < 0.72:
            return
    if(life > 2):
        if randf() < 0.82:
            return
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.set_offset(randi())
    # Create a Mob instance and add it to the scene.
    var mob = Life.instance()
    add_child(mob)
    # Set the mob's direction perpendicular to the path direction.
    var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position
    # Add some randomness to the direction.
    direction = 0#rand_range(-PI / 4, PI / 4)
    mob.rotation = direction
    # Choose the velocity.
    mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))


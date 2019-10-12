extends KinematicBody2D

const SPEED = 80
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

const ATTACK = preload("res://Attack.tscn")

var velocity = Vector2()
var on_ground = false

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
			
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
	elif Input.is_key_pressed(KEY_A):
		$AnimatedSprite.play("attack")
		velocity.x = 0
	elif Input.is_action_pressed("ui_down"):
		$AnimatedSprite.play("crouch")
		velocity.x = 0
		velocity.y = -JUMP_POWER*2
	else:
		velocity.x = 0
		if on_ground == true:
			$AnimatedSprite.play("idle")
		
	if Input.is_action_pressed("ui_up"):
		if on_ground == true:
			velocity.y = JUMP_POWER
			on_ground = false
	
	velocity.y += GRAVITY
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
	
	velocity = move_and_slide(velocity, FLOOR)
	
#shoot swooshes on key press
func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_A) and just_pressed:
		var attack = ATTACK.instance()
		attack.set_swoosh_direction(sign($Position2D.position.x))
		get_parent().add_child(attack)
		attack.position = $Position2D.global_position
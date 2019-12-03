extends Area2D

#signal
signal hit
#var
var move_speed
var screen_size
var is_safe

func _ready():
	self.init()
	screen_size = get_viewport_rect().size
	self.connect("body_entered",self,"on_body_entered")
	$SafeTimer.connect("timeout",self,"on_SafeTimer_timeout")
	
func init():
	is_safe = false
	move_speed = 400
	
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * move_speed
		self.move(velocity,delta)
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

func on_accelerate():
	self.move_speed += 50
		
func move(velocity,delta):
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	
func on_body_entered(body:PhysicsBody2D):
	print_debug(self.is_safe)
	print_debug(body.collision_layer)
	print_debug(ProjectConstant.food_layer)
	if self.is_safe or body.collision_layer == ProjectConstant.food_layer:
		return
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	self.init()
	show()
	$CollisionShape2D.set_deferred("disabled",false)
	
func on_get_food():
	print_debug("‰Ω†Â∑≤ÁªèÊó†Êïå‰∫Ü")
	self.is_safe = true
	$SafeTimer.wait_time = 3
	$SafeTimer.start()

func on_SafeTimer_timeout():
	print_debug("Êó†ÊïåÌ†æÌ¥£Ì†æÊ∂àÂ§±‰∫Ü")
	self.is_safe = false

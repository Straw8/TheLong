extends Area2D

#signal
signal hit
signal update_life_pic
#var
var move_speed
var screen_size
var is_safe
var life_count
var current_timer
var target = Vector2()	#存储点击的位置

func _ready():
	self.init()
	screen_size = get_viewport_rect().size
	self.connect("body_entered",self,"on_body_entered")
	$SafeTimer.connect("timeout",self,"on_SafeTimer_timeout")
	$FlashTimer.connect("timeout",self,"on_FlashTimer_timeout")
	$TimerManager.connect("timeout",self,"on_TimerManager_timeout")
	
func init():
	is_safe = false
	move_speed = 400
	life_count = 1
	target = position	#初始化位置

# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta):
	var velocity = Vector2() 
	
	# Move towards the target and stop when close.
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * move_speed
	else:
		velocity = Vector2()
		
	# Remove keyboard controls.
	 # The player's movement vector.
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * move_speed
		self.move(velocity,delta)
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

func on_accelerate():
	self.move_speed += 100
		
func move(velocity,delta):
	position += velocity * delta
	
	# We don't need to clamp the player's position
	# because you can't click outside the screen.
#	position.x = clamp(position.x, 0, screen_size.x)
#	position.y = clamp(position.y, 0, screen_size.y)
	
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	
func on_body_entered(body):
	if self.is_safe or body.collision_layer == ProjectConstant.food_layer:
		return
	if life_count > 1:
		life_count -= 1
		emit_signal("update_life_pic",-1)
		self.current_timer = $FlashTimer
		$FlashTimer.start()
		$TimerManager.start()
		return
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func on_FlashTimer_timeout():
	$AnimatedSprite.visible = !$AnimatedSprite.visible

func on_TimerManager_timeout():
	if current_timer:
		current_timer.stop()
		$AnimatedSprite.visible = true

func start(pos):
	position = pos
	self.init()
	show()
	$CollisionShape2D.set_deferred("disabled",false)
	
func on_get_food():
	$StateLabel.visible = true
	self.is_safe = true
	$SafeTimer.wait_time = 3
	$SafeTimer.start()

func on_SafeTimer_timeout():
	$StateLabel.visible = false
	self.is_safe = false
	
func on_get_life():
	if life_count < 3:
		life_count += 1
		emit_signal("update_life_pic",1)
		
	
